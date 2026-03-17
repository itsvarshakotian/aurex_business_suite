import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/resources/color_resources.dart';
import 'reports_controller.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportsController>();

    return SafeArea(
      child: SingleChildScrollView(
        padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Title
            Text(
              "Reports",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            /// Filter Row
            Obx(() => Row(
                  children: ["This Week", "This Month", "This Year"]
                      .map((filter) {
                    final selected =
                        controller.selectedFilter.value == filter;

                    return GestureDetector(
                      onTap: () =>
                          controller.changeFilter(filter),
                      child: Container(
                        margin:
                            const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(20),
                          color: selected
                              ? Colors.white
                              : const Color(0xFF1A1D24),
                        ),
                        child: Text(
                          filter,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: selected
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )),

            const SizedBox(height: 32),

            /// Summary Cards Row
            Row(
              children: [
                Expanded(
                  child: buildSummaryCard(
                    "Total Sales",
                    controller.totalRevenue,
                    prefix: "₹",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: buildSummaryCard(
                    "Orders",
                    controller.totalOrders,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Full Width Card
            buildSummaryCard(
              "Products Sold",
              controller.totalProducts,
            ),

            const SizedBox(height: 32),

            /// Revenue Chart
           /// Revenue Chart
Obx(() {
  final chartData = controller.revenueChart;

  if (chartData.isEmpty) {
    return Container(
      height: 220,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Text(
        "No data available",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  final maxValue =
      chartData.reduce((a, b) => a > b ? a : b);

  return Container(
    height: 220,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF1A1D24),
      borderRadius: BorderRadius.circular(28),
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
            color: Colors.white,
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.white.withValues(alpha: 0.05),
            ),
            spots: chartData
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
  );
}),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Summary Card Widget (Safe Version)
  Widget buildSummaryCard(
    String title,
    Rx value, {
    String prefix = "",
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: ColorResources.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "$prefix${value.value}",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          )),
    );
  }
}