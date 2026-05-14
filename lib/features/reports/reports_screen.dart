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

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0B1220),
              Color(0xFF0F172A),
              Color(0xFF020617),
            ],
          ),
        ),

        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await controller.loadReports();
            },

            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 24),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// HEADER
                  Text(
                    "Reports",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// FILTER
                  Obx(() {
                    return Row(
                      children: [
                        "This Week",
                        "This Month",
                        "This Year"
                      ].map((f) {
                        final selected =
                            controller.selectedFilter.value == f;

                        return GestureDetector(
                          onTap: () => controller.changeFilter(f),
                          child: AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 200),
                            margin:
                                const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(20),
                              color: selected
                                  ? ColorResources.profileCircle(context)
                                  : Colors.white.withOpacity(0.05),
                              border: Border.all(
                                color: selected
                                    ? ColorResources.profileCircle(context)
                                    : Colors.white.withOpacity(0.1),
                              ),
                            ),
                            child: Text(
                              f,
                              style: TextStyle(
                                color: selected
                                    ? Colors.black
                                    : Colors.white
                                        .withOpacity(0.6),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),

                  const SizedBox(height: 28),

                  /// KPI
                  Row(
                    children: [
                      Expanded(
                        child: _card(
                          context,"Revenue",
                          controller.totalRevenue,
                          prefix: "₹",
                          icon: Icons.trending_up,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _card(
                          context,"Orders",
                          controller.totalOrders,
                          icon: Icons.shopping_cart,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _card(
                    context,"Products Sold",
                    controller.totalProducts,
                    icon: Icons.inventory,
                  ),

                  const SizedBox(height: 28),

                  /// CHART
                  Obx(() {
                    final data = controller.revenueChart;

                    if (controller.isLoading.value) {
                      return const SizedBox(
                        height: 220,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (data.isEmpty) {
                      return const SizedBox(
                        height: 220,
                        child: Center(child: Text("No data")),
                      );
                    }

                    final max =
                        data.reduce((a, b) => a > b ? a : b);

                    return Container(
                      height: 220,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(24),
                        color:
                            Colors.white.withOpacity(0.04),
                        border: Border.all(
                          color:
                              Colors.white.withOpacity(0.08),
                        ),
                      ),
                      child: LineChart(
                        LineChartData(
                          minY: 0,
                          maxY: max * 1.2,
                          titlesData:
                              FlTitlesData(show: false),
                          borderData:
                              FlBorderData(show: false),

                          /// INTERACTION
                          lineTouchData: LineTouchData(
                            handleBuiltInTouches: true,
                            touchTooltipData:
                                LineTouchTooltipData(
                              getTooltipItems: (spots) {
                                return spots.map((e) {
                                  return LineTooltipItem(
                                    "₹${_format(e.y)}",
                                    const TextStyle(
                                        color: Colors.white),
                                  );
                                }).toList();
                              },
                            ),
                          ),

                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              color:
                                  ColorResources.profileCircle(context),
                              barWidth: 4,
                              dotData:
                                  FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    ColorResources.profileCircle(context)
                                        .withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              spots: data
                                  .asMap()
                                  .entries
                                  .map((e) => FlSpot(
                                      e.key.toDouble(),
                                      e.value))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 28),

                  /// INSIGHTS
                  Obx(() {
                    final data = controller.revenueChart;

                    if (data.isEmpty) return const SizedBox();

                    final maxValue =
                        data.reduce((a, b) => a > b ? a : b);

                    final avgOrder =
                        controller.totalOrders.value == 0
                            ? 0
                            : controller.totalRevenue.value /
                                controller.totalOrders.value;

                    return Row(
                      children: [
                        Expanded(
                          child: _customInsight(
                           context, "Top Day",
                            "₹${_format(maxValue)}",
                            Icons.star,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _customInsight(
                            context,"Avg Order",
                            "₹${_format(avgOrder)}",
                            Icons.analytics,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _customInsight(
                            context,"Best Revenue",
                            "₹${_format(maxValue)}",
                            Icons.trending_up,
                          ),
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 28),

                  /// RECENT ACTIVITY (REAL DATA)
             Builder(
  builder: (_) {
                    final orders = controller.allOrders;

                    if (orders.isEmpty) {
                      return const SizedBox();
                    }

                    final recent =
                        orders.reversed.take(3).toList();

                    return Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Recent Activity",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 12),

                        ...recent.map((order) {
                          return GestureDetector(
                            onTap: () {},

                            child: Container(
                              margin: const EdgeInsets.only(
                                  bottom: 10),
                              padding:
                                  const EdgeInsets.all(14),

                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(
                                        16),
                                color: Colors.white
                                    .withOpacity(0.04),
                                border: Border.all(
                                  color: Colors.white
                                      .withOpacity(0.08),
                                ),
                              ),

                              child: Row(
                                children: [

                                  Container(
                                    padding:
                                        const EdgeInsets
                                            .all(8),
                                    decoration:
                                        BoxDecoration(
                                      shape:
                                          BoxShape.circle,
                                      color:
                                          ColorResources
                                              .profileCircle(context)
                                              .withOpacity(
                                                  0.2),
                                    ),
                                    child: Icon(
                                      Icons.receipt_long,
                                      size: 16,
                                      color: ColorResources
                                          .profileCircle(context),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: Text(
                                      "Order #${order.id} • ₹${_format(order.total)}",
                                      style: TextStyle(
                                        color: Colors.white
                                            .withOpacity(
                                                0.8),
                                      ),
                                    ),
                                  ),

                                  Text(
                                    "${order.date.day}/${order.date.month}",
                                    style: TextStyle(
                                      color: Colors.white
                                          .withOpacity(0.4),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// KPI CARD
  Widget _card(BuildContext context,String title, Rx value,
      {String prefix = "", IconData? icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.04),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Obx(() => Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: Colors.white
                              .withOpacity(0.6))),
                  const SizedBox(height: 6),
                  Text(
                    "$prefix${_format(value.value)}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              if (icon != null)
                Icon(icon,
                    color: ColorResources.profileCircle(context)),
            ],
          )),
    );
  }

  /// INSIGHT
  Widget _customInsight(BuildContext context,
      String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(icon,
              color: ColorResources.profileCircle(context), size: 18),
          const SizedBox(height: 6),
          Text(title,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 11)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  /// FORMAT
  String _format(num value) {
    if (value >= 1000000) {
      return "${(value / 1000000).toStringAsFixed(1)}M";
    } else if (value >= 1000) {
      return "${(value / 1000).toStringAsFixed(1)}K";
    }
    return value.toString();
  }
}