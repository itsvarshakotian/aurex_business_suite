import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/resources/color_resources.dart';
import '../../core/services/auth_service.dart';
import 'orders_controller.dart';
import 'order_detail_screen.dart';
import 'orders_history_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(OrdersController());
    final auth = Get.find<AuthService>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        /// Staff cannot create orders
        floatingActionButton: auth.isStaff
            ? null
            : FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  controller.createOrder();
                },
                child: const Icon(Icons.add, color: Colors.black),
              ),

        body: RefreshIndicator(
          onRefresh: controller.fetchOrders,

          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Row(
                  children: [

                    Text(
                      "Orders",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    const Spacer(),

                    GestureDetector(
                      onTap: () {
                        Get.to(() => const OrdersHistoryScreen());
                      },
                      child: Text(
                        "History",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                /// ORDER LIST
                Obx(() {

                  if (controller.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (controller.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (controller.orders.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Center(
                        child: Text(
                          "No orders found",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.orders.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 16),

                    itemBuilder: (context, index) {

                      final order = controller.orders[index];

                      return Column(
                        children: order.products.map((product) {

                          return GestureDetector(
                            onTap: () {
                              Get.to(() => CreateOrderScreen(order: order));
                            },

                            child: Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(bottom: 12),

                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1D24),
                                borderRadius: BorderRadius.circular(20),
                              ),

                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,

                                children: [

                                  /// PRODUCT IMAGE
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    clipBehavior: Clip.hardEdge,

                                    child: product.thumbnail.isEmpty
                                        ? const Icon(
                                            Icons.image,
                                            size: 30,
                                            color: Colors.grey,
                                          )
                                        : Image.network(
                                            product.thumbnail,
                                            fit: BoxFit.cover,

                                            loadingBuilder:
                                                (context, child, progress) {
                                              if (progress == null) {
                                                return child;
                                              }

                                              return const Center(
                                                child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  ),
                                                ),
                                              );
                                            },

                                            errorBuilder: (context,
                                                error, stackTrace) {
                                              return const Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                              );
                                            },
                                          ),
                                  ),

                                  const SizedBox(width: 16),

                                  /// PRODUCT DETAILS
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [

                                        /// TITLE
                                        Text(
                                          product.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,

                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),

                                        const SizedBox(height: 6),

                                        /// PRICE
                                        Text(
                                          "₹${product.price.toStringAsFixed(0)}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: ColorResources
                                                .textSecondary,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        /// QUANTITY
                                        Text(
                                          "Qty: ${product.quantity}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: ColorResources
                                                .textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                        }).toList(),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}