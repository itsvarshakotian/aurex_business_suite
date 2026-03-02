import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/resources/color_resources.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 👋 Welcome Header
              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome back,",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: ColorResources.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        controller.userRole.value,
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),

              const SizedBox(height: 32),

              /// 📈 Performance
              Text(
                "Performance",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              Container(
                height: 180,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1D24),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        color: Colors.white,
                        barWidth: 3,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.white.withOpacity(0.05),
                        ),
                        spots: controller.weeklySales
                            .asMap()
                            .entries
                            .map(
                              (e) => FlSpot(
                                e.key.toDouble(),
                                e.value,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              /// ⚡ Quick Actions
              Text(
                "Quick Actions",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  buildActionButton(Icons.add, "Create Order"),
                  buildActionButton(Icons.inventory_2, "Add Product"),
                ],
              ),

              const SizedBox(height: 32),

              /// 📊 Stats
              Text(
                "Overview",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 1.2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [

                  buildStatCard(
                    "Sales",
                    animatedInt(controller.salesCount),
                  ),

                  buildStatCard(
                    "Revenue",
                    animatedDouble(controller.revenue, prefix: "₹"),
                  ),

                  buildStatCard(
                    "Active Users",
                    animatedInt(controller.activeUsers),
                  ),

                  buildStatCard(
                    "Pending Tasks",
                    animatedInt(controller.pendingTasks),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatCard(String title, Widget child) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: ColorResources.textSecondary,
            ),
          ),
          const Spacer(),
          child,
        ],
      ),
    );
  }

  Widget animatedInt(RxInt value) {
    return Obx(() => TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: value.value.toDouble()),
          duration: const Duration(milliseconds: 800),
          builder: (context, val, _) {
            return Text(
              val.toInt().toString(),
              style: valueStyle(),
            );
          },
        ));
  }

  Widget animatedDouble(RxDouble value, {String prefix = ""}) {
    return Obx(() => TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: value.value),
          duration: const Duration(milliseconds: 800),
          builder: (context, val, _) {
            return Text(
              "$prefix${val.toStringAsFixed(0)}",
              style: valueStyle(),
            );
          },
        ));
  }

  Widget buildActionButton(IconData icon, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D24),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: ColorResources.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle valueStyle() {
    return GoogleFonts.poppins(
      fontSize: 26,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }
}