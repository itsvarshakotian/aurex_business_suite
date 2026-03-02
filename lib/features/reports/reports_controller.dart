import 'package:get/get.dart';

class ReportsController extends GetxController {
  final RxString selectedFilter = "This Week".obs;

  final RxDouble totalSales = 0.0.obs;
  final RxInt totalOrders = 0.obs;
  final RxInt totalProducts = 0.obs;

  final List<double> weeklyRevenue = [2000, 3500, 2800, 4500, 5200, 6100, 4800];

  @override
  void onInit() {
    super.onInit();
    loadReport();
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
    loadReport();
  }

  void loadReport() async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (selectedFilter.value == "This Week") {
      totalSales.value = 28500;
      totalOrders.value = 42;
      totalProducts.value = 18;
    } else if (selectedFilter.value == "This Month") {
      totalSales.value = 124000;
      totalOrders.value = 180;
      totalProducts.value = 64;
    } else {
      totalSales.value = 1420000;
      totalOrders.value = 2140;
      totalProducts.value = 480;
    }
  }
}