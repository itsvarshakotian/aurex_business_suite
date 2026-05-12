import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/utils/no_internet_widget.dart';
import '../../core/resources/color_resources.dart';
import '../profile/profile_binding.dart';
import '../profile/profile_screen.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    /// PAGE CONTROLLER
    final PageController pageController = PageController(
      viewportFraction: 0.88,
    );

    /// AUTO SLIDER
    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!pageController.hasClients) return;

      int nextPage = pageController.page!.round() + 1;

      if (nextPage > 2) {
        nextPage = 0;
      }

      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B1220), Color(0xFF0F172A), Color(0xFF020617)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Obx(() {
            if (controller.noInternet.value) {
              return NoInternetWidget(onRetry: controller.loadDashboard);
            }

            return RefreshIndicator(
              onRefresh: controller.loadDashboard,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dashboard",
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Welcome back",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => const ProfileScreen(),
                              binding: ProfileBinding(),
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withValues(alpha: 0.1),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// HERO CARDS
                    SizedBox(
                      height: 170,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 135,
                            child: PageView(
                              controller: pageController,
                              children: [
                                heroCard(
                                  "Revenue",
                                  "₹${controller.animatedRevenue.value.toStringAsFixed(0)}",
                                  "+12%",
                                  Colors.blue,
                                  Icons.trending_up,
                                ),

                                heroCard(
                                  "Sales",
                                  controller.salesCount.value.toString(),
                                  "+8%",
                                  Colors.indigo,
                                  Icons.shopping_cart,
                                ),

                                heroCard(
                                  "Users",
                                  controller.activeUsers.value.toString(),
                                  "+5%",
                                  Colors.purple,
                                  Icons.people,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// DOTS
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) {
                              return AnimatedBuilder(
                                animation: pageController,
                                builder: (context, child) {
                                  double page = pageController.hasClients
                                      ? pageController.page ?? 0
                                      : 0;

                                  final isActive = page.round() == index;

                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    width: isActive ? 16 : 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: isActive
                                          ? ColorResources.goldPrimary
                                          : Colors.white.withValues(alpha: 0.3),
                                    ),
                                  );
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// CHART
                    sectionTitle("Revenue Overview"),
                    const SizedBox(height: 16),
                    revenueChart(controller),

                    const SizedBox(height: 30),

                    /// INSIGHTS
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle("Quick Insights"),
                        const SizedBox(height: 4),
                        Text(
                          "Overview of current system status",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha:0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: controller.orderStatusCount.entries.map((e) {
                          return insightCard(e.key, e.value);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  /// HERO CARD (unchanged)
  Widget heroCard(
    String title,
    String value,
    String change,
    Color color,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.35), color.withValues(alpha: 0.08)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white),
              Text(
                change,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(title, style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
        ],
      ),
    );
  }

  Widget insightCard(String title, int value) {
    final isHigh = value > 10;

    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(
          color: isHigh
              ? Colors.red.withValues(alpha: 0.4)
              : Colors.green.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
          const SizedBox(height: 10),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isHigh ? "Needs attention" : "All good",
            style: TextStyle(
              fontSize: 12,
              color: isHigh ? Colors.red : Colors.green,
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
        color: Colors.white,
      ),
    );
  }

  Widget revenueChart(DashboardController controller) {
    final values = controller.monthlyRevenue.values.toList();

    if (values.isEmpty) {
      return const Center(child: Text("No Data"));
    }

    final maxValue = values.reduce((a, b) => a > b ? a : b);

    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withValues(alpha: 0.04),
      ),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxValue * 1.3,
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: ColorResources.goldPrimary,
              barWidth: 4,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    ColorResources.goldPrimary.withValues(alpha: 0.3),
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
}
