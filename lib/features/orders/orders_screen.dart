import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/resources/color_resources.dart';
import 'orders_controller.dart';
import 'create_order_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrdersController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            Get.to(() => const CreateOrderScreen());
          },
          child: const Icon(Icons.add, color: Colors.black),
        ),
        body: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Orders",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 28),

              Obx(() {
                return ListView.separated(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  itemCount: controller.orders.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final order =
                        controller.orders[index];

                    Color statusColor;
                    switch (order["status"]) {
                      case "Completed":
                        statusColor = Colors.green;
                        break;
                      case "Pending":
                        statusColor = Colors.orange;
                        break;
                      default:
                        statusColor = Colors.red;
                    }

                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1D24),
                        borderRadius:
                            BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                            children: [
                              Text(
                                order["id"],
                                style:
                                    GoogleFonts.poppins(
                                  fontSize: 14,
                                  color:
                                      ColorResources
                                          .textSecondary,
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                            horizontal: 12,
                                            vertical: 6),
                                decoration:
                                    BoxDecoration(
                                  color: statusColor
                                      .withOpacity(0.15),
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              20),
                                ),
                                child: Text(
                                  order["status"],
                                  style: GoogleFonts
                                      .poppins(
                                    fontSize: 12,
                                    fontWeight:
                                        FontWeight
                                            .w500,
                                    color:
                                        statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Text(
                            order["customer"],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "₹${order["amount"]}",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color:
                                  ColorResources
                                      .textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}