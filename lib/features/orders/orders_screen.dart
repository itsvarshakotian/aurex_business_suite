import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/resources/color_resources.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/no_internet_widget.dart';
import 'orders_controller.dart';
import 'order_detail_screen.dart';
import 'orders_history_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.find<OrdersController>();
    final auth = Get.find<AuthService>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        // Staff cannot create orders
        floatingActionButton: auth.isStaff
            ? null
            : FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: controller.createOrder,
                child: const Icon(Icons.add, color: Colors.black),
              ),

        body: Obx(() {
          // LOADING (FIRST LOAD)
          if (controller.isLoading.value && controller.orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // NO INTERNET
          if (controller.errorMessage.value == "No internet connection") {
            return NoInternetWidget(
              onRetry: controller.fetchOrders,
            );
          }

          // EMPTY STATE
          if (controller.orders.isEmpty) {
            return const Center(
              child: Text(
                "No orders found",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          // MAIN LIST WITH PAGINATION
          return RefreshIndicator(
            onRefresh: () => controller.fetchOrders(),

            child: ListView.builder(
              controller: controller.scrollController,
              padding: const EdgeInsets.all(24),

              itemCount: controller.orders.length + 1,

              itemBuilder: (context, index) {
                // BOTTOM LOADER
                if (index == controller.orders.length) {
                  return Obx(() {
                    return controller.isMoreLoading.value
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                                child: CircularProgressIndicator()),
                          )
                        : const SizedBox();
                  });
                }

                final order = controller.orders[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    if (index == 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Row(
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
                                Get.to(() =>
                                    const OrdersHistoryScreen());
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
                      ),

                    /// PRODUCTS
                    ...order.products.map((product) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(() =>
                              CreateOrderScreen(order: order));
                        },

                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),

                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1D24),
                            borderRadius:
                                BorderRadius.circular(20),
                          ),

                          child: Row(
                            children: [
                              // IMAGE
                              Container(
                                width: 60,
                                height: 60,
                                clipBehavior: Clip.hardEdge,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),

                                child: product.thumbnail.isEmpty
                                    ? const Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                      )
                                    : Image.network(
                                        product.thumbnail,
                                        fit: BoxFit.cover,
                                      ),
                              ),

                              const SizedBox(width: 16),

                              // DETAILS
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      maxLines: 1,
                                      overflow:
                                          TextOverflow.ellipsis,
                                      style:
                                          GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight:
                                            FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      "₹${product.price.toStringAsFixed(0)}",
                                      style:
                                          GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: ColorResources
                                            .textSecondary,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      "Qty: ${product.quantity}",
                                      style:
                                          GoogleFonts.poppins(
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
                  ],
                );
              },
            ),
          );
        }),
      ),
    );
  }
}