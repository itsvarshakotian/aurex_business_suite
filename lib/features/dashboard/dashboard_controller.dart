import 'dart:developer';

import 'package:get/get.dart';
import '../../core/services/auth_service.dart';
import '../../data/repositories/orders_repository.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../data/models/order_model.dart';
import '../../data/models/product_model.dart';

class DashboardController extends GetxController {
  final AuthService auth = Get.find<AuthService>();
  final OrdersRepository _ordersRepo = OrdersRepository();
  final InventoryRepository _inventoryRepo = InventoryRepository();

  final RxString userRole = "".obs;

  final RxInt salesCount = 0.obs;
  final RxDouble revenue = 0.0.obs;
  final RxInt activeUsers = 0.obs;
  final RxInt pendingTasks = 0.obs;

  final RxBool isLoading = false.obs;

  ///  Analytics Maps
  final RxMap<String, double> monthlyRevenue =
      <String, double>{}.obs;

  final RxMap<String, int> orderStatusCount =
      <String, int>{}.obs;

  ///  Cached lists
  final RxList<OrderModel> cachedOrders = <OrderModel>[].obs;

  final RxList<ProductModel> cachedProducts = <ProductModel>[].obs;

 bool loaded = false;

@override
void onInit() {
  super.onInit();
  userRole.value = auth.role.value; 

  if (!loaded) {
    loadDashboard();
    loaded = true;
  }
}
  Future<void> loadDashboard() async {
    log("Monthly Revenue: $monthlyRevenue");
    log("Status Count: $orderStatusCount");
    log("Revenue: ${revenue.value}");
    try {
      isLoading.value = true;

      final List<OrderModel> orders =
          await _ordersRepo.fetchOrders();

      final List<ProductModel> products =
          await _inventoryRepo.fetchProducts();

      /// 🔹 BASIC STATS
      salesCount.value = orders.length;

      revenue.value = orders.fold(
        0.0,
        (sum, order) => sum + order.total,
      );

      activeUsers.value = 24; // demo static

      pendingTasks.value =
          products.where((p) => p.stock < 5).length;

      /// 🔹 CACHE DATA
      cachedOrders.assignAll(orders);
      cachedProducts.assignAll(products);

      /// 🔹 MONTHLY REVENUE CALCULATION
    final Map<int, double> dayRevenue = {};

for (var order in orders) {
  final day = order.date.day;

  dayRevenue[day] =
      (dayRevenue[day] ?? 0) + order.total;
}

/// last 7 days
final Map<String, double> finalMap = {};

for (int i = 6; i >= 0; i--) {
  final date = DateTime.now().subtract(Duration(days: i));
  final key = "${date.day}/${date.month}";

  finalMap[key] = dayRevenue[date.day] ?? 0;
}

monthlyRevenue.assignAll(finalMap);

      /// 🔹 ORDER STATUS COUNT
      final Map<String, int> statusMap = {};

      for (var order in orders) {
        statusMap[order.status] =
            (statusMap[order.status] ?? 0) + 1;
      }

      orderStatusCount.assignAll(statusMap);

    } catch (e) {
      // you can add error handling here later
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Getters
  List<OrderModel> get recentOrders =>
      cachedOrders.take(5).toList();

  List<ProductModel> get lowStockProducts =>
      cachedProducts
          .where((p) => p.stock < 5)
          .take(5)
          .toList();
}