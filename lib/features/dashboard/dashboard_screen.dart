import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/resources/color_resources.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Header
            Text(
              "Dashboard",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Overview of your business performance",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: ColorResources.textSecondary,
              ),
            ),

            const SizedBox(height: 32),

            /// Stats Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 1.1,
                children: [

                  _buildStatCard(
                    title: "Sales",
                    child: Obx(() => TweenAnimationBuilder<double>(
                          tween: Tween(
                            begin: 0,
                            end: controller.salesCount.value.toDouble(),
                          ),
                          duration: const Duration(milliseconds: 800),
                          builder: (context, value, _) {
                            return Text(
                              value.toInt().toString(),
                              style: _valueStyle(),
                            );
                          },
                        )),
                  ),

                  _buildStatCard(
                    title: "Revenue",
                    child: Obx(() => TweenAnimationBuilder<double>(
                          tween: Tween(
                            begin: 0,
                            end: controller.revenue.value,
                          ),
                          duration: const Duration(milliseconds: 900),
                          builder: (context, value, _) {
                            return Text(
                              "₹${value.toStringAsFixed(0)}",
                              style: _valueStyle(),
                            );
                          },
                        )),
                  ),

                  _buildStatCard(
                    title: "Active Users",
                    child: Obx(() => TweenAnimationBuilder<double>(
                          tween: Tween(
                            begin: 0,
                            end: controller.activeUsers.value.toDouble(),
                          ),
                          duration: const Duration(milliseconds: 700),
                          builder: (context, value, _) {
                            return Text(
                              value.toInt().toString(),
                              style: _valueStyle(),
                            );
                          },
                        )),
                  ),

                  _buildStatCard(
                    title: "Pending Tasks",
                    child: Obx(() => TweenAnimationBuilder<double>(
                          tween: Tween(
                            begin: 0,
                            end: controller.pendingTasks.value.toDouble(),
                          ),
                          duration: const Duration(milliseconds: 750),
                          builder: (context, value, _) {
                            return Text(
                              value.toInt().toString(),
                              style: _valueStyle(),
                            );
                          },
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F26),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: ColorResources.textSecondary,
            ),
          ),
          const Spacer(),
          child,
        ],
      ),
    );
  }

  TextStyle _valueStyle() {
    return GoogleFonts.poppins(
      fontSize: 26,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }
}