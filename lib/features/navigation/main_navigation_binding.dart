import 'package:get/get.dart';

import '../dashboard/dashboard_controller.dart';
import '../inventory/inventory_controller.dart';
import '../orders/orders_controller.dart';
import '../reports/reports_controller.dart';
import '../profile/profile_controller.dart';
import 'main_navigation_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<MainNavigationController>(
      () => MainNavigationController(),
    );

    Get.lazyPut<DashboardController>(
      () => DashboardController(),
    );

    Get.lazyPut<InventoryController>(
      () => InventoryController(),
    );

    Get.lazyPut<OrdersController>(
      () => OrdersController(),
    );

    Get.lazyPut<ReportsController>(
      () => ReportsController(),
    );

    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}