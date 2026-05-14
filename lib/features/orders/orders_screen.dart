import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Widgets/order_filter_bar.dart';
import '../../app/routes/app_routes.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/no_internet_widget.dart';
import '../../core/resources/color_resources.dart';
import '../../helper/helper.dart';
import 'orders_controller.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersController>();
    final auth = Get.find<AuthService>();

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),

      /// FAB
     floatingActionButton: auth.canCreateOrder
    ? Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: GestureDetector(
          onTap: () async {
            await Get.toNamed(AppRoutes.createOrder);
            await controller.fetchOrders();
          },
          child: Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      )
    : null,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B1220), Color(0xFF0F172A), Color(0xFF020617)],
          ),
        ),

        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await controller.fetchOrders();
            },

            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Text(
                    "Orders",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  ///  KPI STRIP
                  Obx(() {
                    final orders = controller.orders;

                    final pending = orders
                        .where((o) => o.status == "pending")
                        .length;

                    final completed = orders
                        .where((o) => o.status == "completed")
                        .length;

                    final cancelled = orders
                        .where((o) => o.status == "cancelled")
                        .length;

                    return Row(
                      children: [
                        Expanded(child: _kpi(context, "Pending", pending)),
                        const SizedBox(width: 10),
                        Expanded(child: _kpi(context, "Completed", completed)),
                        const SizedBox(width: 10),
                        Expanded(child: _kpi(context, "Cancelled", cancelled)),
                      ],
                    );
                  }),

                  const SizedBox(height: 20),

                  /// FILTER
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white.withOpacity(0.05),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: const OrderFilterBar(),
                  ),

                  const SizedBox(height: 20),

                  /// LIST
                  Obx(() {
                    /// NO INTERNET
                    if (controller.errorMessage.value ==
                        "No internet connection") {
                      return SizedBox(
                        height: 400,
                        child: NoInternetWidget(
                          onRetry: controller.fetchOrders,
                        ),
                      );
                    }

                    /// EMPTY STATE
                    if (controller.filteredOrders.isEmpty) {
                      return SizedBox(
                        height: 400,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.receipt_long,
                                size: 60,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "No orders available",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    /// LIST VIEW
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.filteredOrders.length,

                      itemBuilder: (context, index) {
                        final order = controller.filteredOrders[index];

                        final statusColor = SnackbarHelper.getStatusColor(
                          order.status,
                        );

                        return TweenAnimationBuilder(
                          duration: Duration(milliseconds: 250 + index * 40),
                          tween: Tween<double>(begin: 0, end: 1),

                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 12 * (1 - value)),
                                child: child,
                              ),
                            );
                          },

                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => CreateOrderScreen(order: order));
                            },

                            child: Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.all(16),

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),

                                /// MATCH DASHBOARD STYLE
                                color: Colors.white.withOpacity(0.04),

                                border: Border.all(
                                  color: Colors.white.withOpacity(0.08),
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color: ColorResources.goldPrimary
                                        .withOpacity(0.05),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),

                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  /// LEFT
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Order #${order.id}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      Text(
                                        "${order.products.length} items",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// RIGHT
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "₹${order.total}",
                                        style: const TextStyle(
                                          color: Colors.greenAccent,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: statusColor.withOpacity(0.15),
                                        ),
                                        child: Text(
                                          order.status.toUpperCase(),
                                          style: TextStyle(
                                            color: statusColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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

  ///  KPI CARD
  Widget _kpi(BuildContext context, String title, int value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              color: ColorResources.profileCircle(context),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
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
}
