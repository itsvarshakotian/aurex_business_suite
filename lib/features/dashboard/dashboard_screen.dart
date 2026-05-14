import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/utils/no_internet_widget.dart';
import '../../core/resources/color_resources.dart';
import '../profile/profile_binding.dart';
import '../profile/profile_screen.dart';
import '../orders/orders_controller.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final ordersController = Get.find<OrdersController>();

    /// PAGE CONTROLLER
    final PageController pageController = PageController(
      viewportFraction: 0.88,
    );

    final RxInt currentPage = 0.obs;

    /// auto scroll
    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!pageController.hasClients) return;
      int next = pageController.page!.round() + 1;
      if (next > 2) next = 0;
      pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });

    pageController.addListener(() {
      currentPage.value = pageController.page?.round() ?? 0;
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),

      body: SafeArea(
        child: Obx(() {
          if (controller.noInternet.value) {
            return NoInternetWidget(onRetry: controller.loadDashboard);
          }

          return RefreshIndicator(
            onRefresh: controller.loadDashboard,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dashboard",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            () => const ProfileScreen(),
                            binding: ProfileBinding(),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.1),
                          child: Icon(Icons.person, color: ColorResources.profileCircle(context)),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// HERO
                  SizedBox(
                    height: 160,
                    child: PageView(
                      controller: pageController,
                      children: [
                        _heroCard(
                          "Revenue",
                          "₹${_format(controller.animatedRevenue.value)}",
                          Colors.greenAccent,
                          Icons.trending_up,
                        ),
                        _heroCard(
                          "Orders",
                          controller.salesCount.value.toString(),
                          Colors.blueAccent,
                          Icons.shopping_cart,
                        ),
                        _heroCard(
                          "Users",
                          controller.activeUsers.value.toString(),
                          Colors.purpleAccent,
                          Icons.people,
                        ),
                      ],
                    ),
                  ),

                  ///  SCROLL DOTS
                  const SizedBox(height: 10),
                  Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final active = currentPage.value == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 6,
                          width: active ? 20 : 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: active
                                ? ColorResources.profileCircle(context)
                                : Colors.white.withOpacity(0.2),
                          ),
                        );
                      }),
                    );
                  }),

                  const SizedBox(height: 30),

                  /// 🔥 GRAPH TITLE
                  Text(
                    "Revenue Overview",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Text(
                    "Last 7 days performance",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// GRAPH
                  _chart(context,controller),

                  const SizedBox(height: 20),

                  ///  GROWTH + PEAK
                  Obx(() {
                    final data = controller.monthlyRevenue.values.toList();

                    if (data.length < 2) return const SizedBox();

                    final prev = data[data.length - 2];
                    final curr = data.last;

                    final growth = prev == 0 ? 0 : ((curr - prev) / prev) * 100;

                    final max = data.reduce((a, b) => a > b ? a : b);

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// 🔹 LEFT → Growth
                        Row(
                          children: [
                            Icon(
                              growth >= 0
                                  ? Icons.arrow_upward
                                  : Icons.trending_down,
                              color: growth >= 0 ? Colors.green : Colors.red,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              growth >= 0
                                  ? "+${growth.toStringAsFixed(1)}% growth"
                                  : "${growth.toStringAsFixed(1)}% drop",
                              style: TextStyle(
                                color: growth >= 0 ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        /// 🔹 RIGHT → Highest
                        Row(
                          children: [
                            const Icon(
                              Icons.trending_up,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Highest: ₹${_format(max)}",
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 24),

                  /// 🔥 QUICK STATS
                Obx(() {
  return Row(
    children: [
      Expanded(
        child: _mini(
          context,"Avg",
          "₹${_format(controller.avgRevenue.value)}",
        ),
      ),
      Expanded(
        child: _mini(
          context,"Growth",
          "${controller.growthPercent.value.toStringAsFixed(1)}%",
        ),
      ),
      Expanded(
        child: _mini(
          context,"Conv",
          "${controller.conversionRate.value.toStringAsFixed(0)}%",
        ),
      ),
    ],
  );
}),

                  const SizedBox(height: 24),

                  ///  RECENT ACTIVITY
                  Obx(() {
                    final orders = ordersController.orders;

                    if (orders.isEmpty) return const SizedBox();

                    final recent = orders.reversed.take(5).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Recent Activity",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...recent.map((o) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            width: double.infinity,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white.withOpacity(0.05),
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      o.status == "pending"
                                          ? Icons.timelapse
                                          : Icons.check_circle,
                                      color: o.status == "pending"
                                          ? Colors.orange
                                          : Colors.green,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "Order #${o.id}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${o.date.day}/${o.date.month}",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.4),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  "₹${_format(o.total)} • ${o.status}",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  }),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _heroCard(String title, String value, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.35), color.withOpacity(0.05)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(title, style: TextStyle(color: Colors.white.withOpacity(0.7))),
        ],
      ),
    );
  }

  Widget _chart(BuildContext  context, DashboardController c) {
    final values = c.monthlyRevenue.values.toList();
    if (values.isEmpty) return const SizedBox();

    final max = values.reduce((a, b) => a > b ? a : b);

    return Container(
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1405), Color(0xFF0B0903)],
        ),
      ),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: max * 1.3,
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(show: false),

          lineBarsData: [
            /// 🔥 GOLD GLOW
            LineChartBarData(
              isCurved: true,
              color: ColorResources.profileCircle(context).withOpacity(0.25),
              barWidth: 10,
              dotData: FlDotData(show: false),
              spots: values
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
            ),

            /// 🔥 MAIN GOLD LINE
            LineChartBarData(
              isCurved: true,
              color: ColorResources.profileCircle(context),
              barWidth: 3,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    ColorResources.profileCircle(context).withOpacity(0.3),
                    Colors.transparent,
                  ],
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

  Widget _mini(BuildContext context,String title, String value, {IconData? icon}) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.06),
            Colors.white.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 ICON (OPTIONAL)
          if (icon != null) ...[
            Icon(icon, size: 18, color: ColorResources.goldPrimary),
            const SizedBox(height: 10),
          ],

          /// VALUE (MAIN FOCUS)
          Text(
            value,
            style: TextStyle(
              color: ColorResources.profileCircle(context),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          /// LABEL
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  String _format(num v) {
    if (v >= 1000000) return "${(v / 1000000).toStringAsFixed(1)}M";
    if (v >= 1000) return "${(v / 1000).toStringAsFixed(1)}K";
    return v.toStringAsFixed(0);
  }
}
