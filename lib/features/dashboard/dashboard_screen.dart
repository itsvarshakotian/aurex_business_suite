import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/utils/no_internet_widget.dart';
import '../../core/resources/color_resources.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Scaffold(
      backgroundColor: ColorResources.primaryBackground,
      body: SafeArea(
        child: Obx(() {
          if (controller.noInternet.value) {
            return NoInternetWidget(
              onRetry: controller.loadDashboard,
            );
          }

          if (controller.userRole.value == "Admin") {
            return adminDashboard(controller);
          }

          if (controller.userRole.value == "Manager") {
            return managerDashboard(controller);
          }

          return staffDashboard(controller);
        }),
      ),
    );
  }

  // ================= ADMIN =================
  Widget adminDashboard(DashboardController controller) {
    return RefreshIndicator(
      onRefresh: controller.loadDashboard,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Dashboard",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: ColorResources.textPrimary,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Welcome back, ${controller.userRole.value}",
              style: const TextStyle(color: ColorResources.textSecondary),
            ),

            const SizedBox(height: 30),

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                statCard("Sales", controller.salesCount.value.toString()),
                statCard("Revenue", "₹${controller.revenue.value.toStringAsFixed(0)}"),
                statCard("Active Users", controller.activeUsers.value.toString()),
                statCard("Low Stock", controller.pendingTasks.value.toString()),
              ],
            ),

            const SizedBox(height: 30),

            sectionTitle("Revenue (Last 7 Days)"),
            const SizedBox(height: 12),

            revenueChart(controller),
          ],
        ),
      ),
    );
  }

  // ================= MANAGER =================
  Widget managerDashboard(DashboardController controller) {
    return RefreshIndicator(
      onRefresh: controller.loadDashboard,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Dashboard",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: ColorResources.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Welcome ${controller.userRole.value}",
              style: const TextStyle(color: ColorResources.textSecondary),
            ),

            const SizedBox(height: 30),

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                statCard("Total Orders", controller.salesCount.value.toString()),
                statCard("Revenue", "₹${controller.revenue.value.toStringAsFixed(0)}"),
                statCard("Low Stock", controller.lowStockProducts.length.toString()),
                statCard("Pending Tasks", controller.pendingTasks.value.toString()),
              ],
            ),

            const SizedBox(height: 30),

            sectionTitle("Revenue (Last 7 Days)"),
            const SizedBox(height: 12),

            revenueChart(controller),

            const SizedBox(height: 30),

            sectionTitle("Order Status"),
            const SizedBox(height: 12),

            ...controller.orderStatusCount.entries.map((entry) {
              return containerCard(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key,
                        style: const TextStyle(color: ColorResources.textPrimary)),
                    Text(entry.value.toString(),
                        style: const TextStyle(color: ColorResources.textSecondary)),
                  ],
                ),
              );
            }),

            const SizedBox(height: 30),

            sectionTitle("Low Stock Products"),
            const SizedBox(height: 12),

            ...controller.lowStockProducts.map((product) {
              return containerCard(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(product.title,
                          style: const TextStyle(color: ColorResources.textPrimary)),
                    ),
                    Text("Stock ${product.stock}",
                        style: const TextStyle(color: ColorResources.error)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ================= STAFF =================
  Widget staffDashboard(DashboardController controller) {
    return RefreshIndicator(
      onRefresh: controller.loadDashboard,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Dashboard",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: ColorResources.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Welcome Staff",
              style: TextStyle(color: ColorResources.textSecondary),
            ),

            const SizedBox(height: 30),

            sectionTitle("Quick Actions"),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                statCard("Create Order", "+"),
                statCard("Orders Today", controller.salesCount.value.toString()),
                statCard(
                    "Pending Orders",
                    controller.orderStatusCount["Pending"]?.toString() ?? "0"),
                statCard(
                    "Completed Orders",
                    controller.orderStatusCount["Completed"]?.toString() ?? "0"),
              ],
            ),

            const SizedBox(height: 30),

            sectionTitle("Low Stock Alerts"),
            const SizedBox(height: 12),

            ...controller.lowStockProducts.map((product) {
              return containerCard(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(product.title,
                          style: const TextStyle(color: ColorResources.textPrimary)),
                    ),
                    Text("Stock ${product.stock}",
                        style: const TextStyle(color: ColorResources.error)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ================= COMMON =================

  Widget statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorResources.secondaryBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ColorResources.borderLight),
        boxShadow: [
          BoxShadow(
            color: ColorResources.shadow.withOpacity(0.6),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(title,
              style: const TextStyle(color: ColorResources.textSecondary)),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: ColorResources.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: ColorResources.textPrimary,
      ),
    );
  }

  Widget containerCard(Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorResources.secondaryBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorResources.borderLight),
      ),
      child: child,
    );
  }

  Widget revenueChart(DashboardController controller) {
    final values = controller.monthlyRevenue.values.toList();

    if (values.isEmpty) {
      return containerCard(
        const Center(
          child: Text(
            "No data",
            style: TextStyle(color: ColorResources.textSecondary),
          ),
        ),
      );
    }

    final maxValue = values.reduce((a, b) => a > b ? a : b);

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorResources.secondaryBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxValue * 1.2,
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: ColorResources.goldPrimary,
              barWidth: 3,
              dotData: FlDotData(show: false),

              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    ColorResources.goldPrimary.withOpacity(0.25),
                    const Color(0x00000000),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),

              spots: values
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}