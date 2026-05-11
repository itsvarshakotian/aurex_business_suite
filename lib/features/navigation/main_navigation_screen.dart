import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/auth_service.dart';
import '../dashboard/dashboard_screen.dart';
import '../inventory/inventory_screen.dart';
import '../orders/orders_screen.dart';
import '../reports/reports_screen.dart';
import 'main_navigation_controller.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
Widget build(BuildContext context) {

  final controller = Get.find<MainNavigationController>();
  final auth = Get.find<AuthService>();

  return Obx(() {

    /// 🔥 NOW ROLE IS REACTIVE
    List<Widget> pages;
    List<IconData> icons;

    if (auth.isAdmin) {
      pages = const [
        DashboardScreen(),
        InventoryScreen(),
        OrdersScreen(),
        ReportsScreen(),
      ];

      icons = [
        Icons.dashboard_outlined,
        Icons.inventory_2_outlined,
        Icons.receipt_long_outlined,
        Icons.bar_chart_outlined,
      ];

    } else if (auth.isManager) {

      pages = const [
        DashboardScreen(),
        OrdersScreen(),
        ReportsScreen(),
      ];

      icons = [
        Icons.dashboard_outlined,
        Icons.receipt_long_outlined,
        Icons.bar_chart_outlined,
      ];

    } else {

      pages = const [
        DashboardScreen(),
        OrdersScreen(),
      ];

      icons = [
        Icons.dashboard_outlined,
        Icons.receipt_long_outlined,
      ];
    }

    /// Prevent index crash
    if (controller.currentIndex.value >= pages.length) {
      controller.currentIndex.value = 0;
    }

    return Scaffold(

      body: pages[controller.currentIndex.value],

      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(30),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: List.generate(icons.length, (index) {

            final isActive =
                controller.currentIndex.value == index;

            return GestureDetector(
              onTap: () => controller.changeTab(index),

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 10),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isActive
                      ? Colors.white
                      : Colors.transparent,
                ),

                child: Icon(
                  icons[index],
                  color: isActive
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
            );
          }),
        ),
      ),
    );
  });
}
}