import 'dart:developer';

import 'package:get/get.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/connectivity_service.dart';
import '../../data/repositories/orders_repository.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../data/models/order_model.dart';
import '../../data/models/product_model.dart';

class DashboardController extends GetxController {

  /// ================= DEPENDENCIES =================
  final AuthService auth = Get.find<AuthService>();
  final OrdersRepository _ordersRepo = OrdersRepository();
  final InventoryRepository _inventoryRepo = InventoryRepository();

  /// ================= STATE =================
  final RxString userRole = "".obs;

  final RxInt salesCount = 0.obs;
  final RxDouble revenue = 0.0.obs;
  final RxInt activeUsers = 0.obs;
  final RxInt pendingTasks = 0.obs;
  final RxBool noInternet = false.obs;

  final RxBool isLoading = false.obs;

  ///  Animated UI value
  final RxDouble animatedRevenue = 0.0.obs;

  /// ================= ANALYTICS =================
  final RxMap<String, double> monthlyRevenue =
      <String, double>{}.obs;

  final RxMap<String, int> orderStatusCount =
      <String, int>{}.obs;

  /// ================= CACHE =================
  final RxList<OrderModel> cachedOrders = <OrderModel>[].obs;
  final RxList<ProductModel> cachedProducts = <ProductModel>[].obs;

  /// ================= LIFECYCLE =================
  @override
  void onInit() {
    super.onInit();
    userRole.value = auth.role.value;

    loadDashboard();
  }

  /// ================= MAIN API =================
  Future<void> loadDashboard() async {
    try {
      isLoading.value = true;

      /// 🔌 Internet check
      final hasInternet = await ConnectivityService().hasInternet();

      if (!hasInternet) {
        noInternet.value = true;
        return;
      } else {
        noInternet.value = false;
      }

      ///  Reset old data
      _resetData();

      /// Fetch data
      final List<OrderModel> orders =
          await _ordersRepo.fetchOrders();

      final List<ProductModel> products =
          await _inventoryRepo.fetchProducts();

      /// BASIC STATS
      salesCount.value = orders.length;

      revenue.value = orders.fold(
        0.0,
        (sum, order) => sum + order.total,
      );

      activeUsers.value = 24; //Hardcoded data

      pendingTasks.value =
          products.where((p) => p.stock < 5).length;

      /// Cache
      cachedOrders.assignAll(orders);
      cachedProducts.assignAll(products);

      /// 📈 Monthly Revenue
      _calculateMonthlyRevenue(orders);

      /// ORDER STATUS 
      _calculateOrderStatus(orders);

      ///Animate revenue
      _startRevenueAnimation();

      log("Dashboard Loaded Successfully");

    } catch (e) {
      log("Dashboard Error: $e");
      noInternet.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  /// ================= HELPERS =================

  ///  Reset all data
  void _resetData() {
    salesCount.value = 0;
    revenue.value = 0.0;
    activeUsers.value = 0;
    pendingTasks.value = 0;

    monthlyRevenue.clear();
    orderStatusCount.clear();
    cachedOrders.clear();
    cachedProducts.clear();
  }

  /// Monthly Revenue
  void _calculateMonthlyRevenue(List<OrderModel> orders) {
    final Map<int, double> dayRevenue = {};

    for (var order in orders) {
      final day = order.date.day;

      dayRevenue[day] =
          (dayRevenue[day] ?? 0) + order.total;
    }

    final Map<String, double> finalMap = {};

    for (int i = 6; i >= 0; i--) {
      final date =
          DateTime.now().subtract(Duration(days: i));

      final key = "${date.day}/${date.month}";

      finalMap[key] = dayRevenue[date.day] ?? 0;
    }

    monthlyRevenue.assignAll(finalMap);
  }

  /// ORDER STATUS FIX (IMPORTANT)
  void _calculateOrderStatus(List<OrderModel> orders) {
    final Map<String, int> statusMap = {
      "pending": 0,
      "completed": 0,
      "cancelled": 0,
    };

    for (var order in orders) {
      final status =
          order.status.trim().toLowerCase();

      log("STATUS: '$status'"); // debug once

      if (statusMap.containsKey(status)) {
        statusMap[status] = statusMap[status]! + 1;
      }
    }

    /// Convert to UI format
    orderStatusCount.assignAll({
      "Pending": statusMap["pending"] ?? 0,
      "Completed": statusMap["completed"] ?? 0,
      "Cancelled": statusMap["cancelled"] ?? 0,
    });
  }

  /// Revenue Animation
  void _startRevenueAnimation() {
    final target = revenue.value;

    animatedRevenue.value = 0;

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 16));

      if (animatedRevenue.value >= target) {
        animatedRevenue.value = target;
        return false;
      }

      /// smooth easing
      animatedRevenue.value +=
          (target - animatedRevenue.value) * 0.2;

      return true;
    });
  }

  /// ================= GETTERS =================

  List<OrderModel> get recentOrders =>
      cachedOrders.take(5).toList();

  List<ProductModel> get lowStockProducts =>
      cachedProducts
          .where((p) => p.stock < 5)
          .take(5)
          .toList();

  /// Helper for consistent status usage
  bool isPending(String status) =>
      status.trim().toLowerCase() == "pending";
}