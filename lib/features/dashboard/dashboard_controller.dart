import 'package:get/get.dart';

class DashboardController extends GetxController {
  final RxInt salesCount = 0.obs;
  final RxDouble revenue = 0.0.obs;
  final RxInt activeUsers = 0.obs;
  final RxInt pendingTasks = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  void loadDashboard() async {
    await Future.delayed(const Duration(milliseconds: 600));

    salesCount.value = 128;
    revenue.value = 54230.75;
    activeUsers.value = 24;
    pendingTasks.value = 7;
  }
}