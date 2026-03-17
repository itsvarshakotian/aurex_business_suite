import 'dart:developer';

import 'package:get/get.dart';
import '../../data/repositories/orders_repository.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../data/models/order_model.dart';
import '../../data/models/product_model.dart';

class ReportsController extends GetxController {
  final OrdersRepository ordersRepo = OrdersRepository();
  final InventoryRepository inventoryRepo = InventoryRepository();

  final RxString selectedFilter = "This Week".obs;
  final RxBool isLoading = false.obs;

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

      allOrders = await ordersRepo.fetchOrders();
      allProducts = await inventoryRepo.fetchProducts();

      applyFilter();
    } catch (e) {
      log("Reports error: $e");
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

    totalOrders.value = filteredOrders.length;

    totalRevenue.value = filteredOrders.fold(
      0.0,
      (sum, order) => sum + order.total,
    );

    totalProducts.value = allProducts.length;

    generateChart(filteredOrders);
    
  }

 void generateChart(List<OrderModel> orders) {
  final Map<int, double> dayRevenue = {};

  // group revenue by day
  for (var order in orders) {
    final day = order.date.day;
    dayRevenue[day] =
        (dayRevenue[day] ?? 0) + order.total;
  }

  // last 7 days chart
  final List<double> chartValues = [];

  for (int i = 6; i >= 0; i--) {
    final day = DateTime.now()
        .subtract(Duration(days: i))
        .day;

    chartValues.add(dayRevenue[day] ?? 0);
  }

  revenueChart.assignAll(chartValues);

  log("Chart Data (7 Days): $revenueChart");
}
}