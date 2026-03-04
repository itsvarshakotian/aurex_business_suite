import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/resources/color_resources.dart';
import 'orders_controller.dart';
import 'order_detail_screen.dart';

class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.find<OrdersController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Recent Orders"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView.separated(
          itemCount: controller.orders.length > 5
              ? 5
              : controller.orders.length,

          separatorBuilder: (_, __) => const SizedBox(height: 16),

          itemBuilder: (context, index) {

            final order = controller.orders[index];

            return GestureDetector(
              onTap: () {
                Get.to(() => CreateOrderScreen(order: order));
              },

              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1D24),
                  borderRadius: BorderRadius.circular(24),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order #${order.id}",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: ColorResources.textSecondary,
                          ),
                        ),

                        const Text(
                          "Recent",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "₹${order.total.toStringAsFixed(0)}",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "${order.totalProducts} Products • ${order.totalQuantity} Items",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: ColorResources.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}