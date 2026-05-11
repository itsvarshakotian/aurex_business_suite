import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/resources/color_resources.dart';
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

      List<Widget> pages;
      List<_NavItem> items;

      if (auth.isAdmin) {
        pages = const [
          DashboardScreen(),
          InventoryScreen(),
          OrdersScreen(),
          ReportsScreen(),
        ];

        items = [
          _NavItem(Icons.dashboard_outlined, "Home"),
          _NavItem(Icons.inventory_2_outlined, "Inventory"),
          _NavItem(Icons.receipt_long_outlined, "Orders"),
          _NavItem(Icons.bar_chart_outlined, "Reports"),
        ];

      } else if (auth.isManager) {
        pages = const [
          DashboardScreen(),
          OrdersScreen(),
          ReportsScreen(),
        ];

        items = [
          _NavItem(Icons.dashboard_outlined, "Home"),
          _NavItem(Icons.receipt_long_outlined, "Orders"),
          _NavItem(Icons.bar_chart_outlined, "Reports"),
        ];

      } else {
        pages = const [
          DashboardScreen(),
          OrdersScreen(),
        ];

        items = [
          _NavItem(Icons.dashboard_outlined, "Home"),
          _NavItem(Icons.receipt_long_outlined, "Orders"),
        ];
      }

      if (controller.currentIndex.value >= pages.length) {
        controller.currentIndex.value = 0;
      }

      final currentIndex = controller.currentIndex.value;

      return Scaffold(
        body: pages[currentIndex],

        /// 🔥 FLOATING NAV
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),

          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: ColorResources.secondaryBackground,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: ColorResources.borderLight,
              ),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (index) {

                final isActive = index == currentIndex;

                return GestureDetector(
                  onTap: () => controller.changeTab(index),

                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,

                    width: isActive ? 60 : 45,
                    height: isActive ? 60 : 45,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? ColorResources.goldPrimary
                          : Colors.transparent,
                    ),

                    child: Center(
                      child: Icon(
                        items[index].icon,
                        size: isActive ? 26 : 22,
                        color: isActive
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      );
    });
  }
}

/// 🔥 MODEL
class _NavItem {
  final IconData icon;
  final String label;

  _NavItem(this.icon, this.label);
}