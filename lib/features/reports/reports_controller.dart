import 'dart:developer';

import 'package:get/get.dart';
import '../../core/utils/connectivity_service.dart';
import '../../data/repositories/orders_repository.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../data/models/order_model.dart';
import '../../data/models/product_model.dart';

class ReportsController extends GetxController {
  final OrdersRepository ordersRepo = OrdersRepository();
  final InventoryRepository inventoryRepo = InventoryRepository();

  final RxString selectedFilter = "This Week".obs;
  final RxBool isLoading = false.obs;
  final RxBool noInternet = false.obs;

  final RxDouble totalRevenue = 0.0.obs;
  final RxInt totalOrders = 0.obs;
  final RxInt totalProducts = 0.obs;

  final RxList<double> revenueChart = <double>[].obs;

  List<OrderModel> allOrders = [];
  List<ProductModel> allProducts = [];

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
    applyFilter();
  }

  Future<void> loadReports() async {
    try {
      isLoading.value = true;
      noInternet.value = false;

      log("Reports Refresh");

      totalRevenue.value = 0;
      totalOrders.value = 0;
      totalProducts.value = 0;
      revenueChart.clear();

      final hasInternet = await ConnectivityService().hasInternet();

      if (!hasInternet) {
        noInternet.value = true;
        return;
      }

      /// 🔥 Parallel API calls (faster)
      final results = await Future.wait([
        ordersRepo.fetchOrders(),
        inventoryRepo.fetchProducts(),
      ]);

      allOrders = results[0] as List<OrderModel>;
      allProducts = results[1] as List<ProductModel>;

      applyFilter();
    } catch (e) {
      log("Reports error: $e");
      noInternet.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilter() {
    DateTime now = DateTime.now();
    List<OrderModel> filteredOrders = [];

    if (selectedFilter.value == "This Week") {
      filteredOrders = allOrders.where((order) {
        return order.date.isAfter(
          now.subtract(const Duration(days: 7)),
        );
      }).toList();
    } else if (selectedFilter.value == "This Month") {
      filteredOrders = allOrders.where((order) {
        return order.date.month == now.month &&
            order.date.year == now.year;
      }).toList();
    } else {
      filteredOrders = allOrders.where((order) {
        return order.date.year == now.year;
      }).toList();
    }

    /// KPIs
    totalOrders.value = filteredOrders.length;

    totalRevenue.value = filteredOrders.fold(
      0.0,
      (sum, order) => sum + order.total,
    );

    /// ⚠️ If this means "sold items", change logic later
    totalProducts.value = allProducts.length;

    /// 🔥 Dynamic chart based on filter
    if (selectedFilter.value == "This Week") {
      _generateWeeklyChart(filteredOrders);
    } else if (selectedFilter.value == "This Month") {
      _generateMonthlyChart(filteredOrders);
    } else {
      _generateYearlyChart(filteredOrders);
    }
  }

  /// 🔥 WEEKLY (7 days)
  void _generateWeeklyChart(List<OrderModel> orders) {
    final Map<String, double> dayRevenue = {};

    for (var order in orders) {
      final key =
          "${order.date.year}-${order.date.month}-${order.date.day}";
      dayRevenue[key] = (dayRevenue[key] ?? 0) + order.total;
    }

    final List<double> chartValues = [];

    for (int i = 6; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      final key = "${date.year}-${date.month}-${date.day}";
      chartValues.add(dayRevenue[key] ?? 0);
    }

    revenueChart.assignAll(chartValues);
  }

  /// 🔥 MONTHLY (last 30 days grouped by day)
  void _generateMonthlyChart(List<OrderModel> orders) {
    final Map<int, double> dayRevenue = {};

    for (var order in orders) {
      final day = order.date.day;
      dayRevenue[day] = (dayRevenue[day] ?? 0) + order.total;
    }

    final List<double> chartValues = [];

    for (int i = 1; i <= 30; i++) {
      chartValues.add(dayRevenue[i] ?? 0);
    }

    revenueChart.assignAll(chartValues);
  }

  /// 🔥 YEARLY (12 months)
  void _generateYearlyChart(List<OrderModel> orders) {
    final Map<int, double> monthRevenue = {};

    for (var order in orders) {
      final month = order.date.month;
      monthRevenue[month] = (monthRevenue[month] ?? 0) + order.total;
    }

    final List<double> chartValues = [];

    for (int i = 1; i <= 12; i++) {
      chartValues.add(monthRevenue[i] ?? 0);
    }

    revenueChart.assignAll(chartValues);
  }
}