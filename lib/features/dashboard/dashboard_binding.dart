import 'package:get/get.dart';

import '../dashboard/dashboard_controller.dart';
import '../navigation/main_navigation_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavigationController>(
      () => MainNavigationController(),
    );

    Get.lazyPut<DashboardController>(
      () => DashboardController(),
    );
  }
}