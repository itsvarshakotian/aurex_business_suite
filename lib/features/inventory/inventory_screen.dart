import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/auth_service.dart';
import '../../core/utils/no_internet_widget.dart';
import 'inventory_controller.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();
    final auth = Get.find<AuthService>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        // Admin only
        floatingActionButton: auth.isAdmin
            ? FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {},
                child: const Icon(Icons.add, color: Colors.black),
              )
            : null,

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // HEADER
              Text(
                "Inventory",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 24),

              // CONTENT
              Expanded(
                child: Obx(() {

                  // LOADING
                  if (controller.isLoading.value &&
                      controller.products.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // NO INTERNET
                  if (controller.errorMessage.value ==
                      "No internet connection") {
                    return NoInternetWidget(
                      onRetry: controller.fetchProducts,
                    );
                  }

                  // ERROR
                  if (controller.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final items = controller.filteredProducts;

                  // EMPTY
                  if (items.isEmpty) {
                    return const Center(
                      child: Text(
                        "No products found",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      await controller.fetchProducts();
                    },

                  // LIST + PAGINATION
            child: ListView.separated(
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: items.length + 1,

                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 16),

                    itemBuilder: (context, index) {

                      // LOAD MORE LOADER
                      if (index == items.length) {
                        return Obx(() =>
                            controller.isMoreLoading.value
                                ? const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(
                                      child:
                                          CircularProgressIndicator(),
                                    ),
                                  )
                                : const SizedBox());
                      }

                      final product = items[index];
                      // STOCK STATUS
                      Color badgeColor;
                      String badgeText;

                      if (product.stock > 10) {
                        badgeColor = Colors.green;
                        badgeText = "In Stock";
                      } else if (product.stock > 3) {
                        badgeColor = Colors.orange;
                        badgeText = "Low Stock";
                      } else {
                        badgeColor = Colors.red;
                        badgeText = "Critical";
                      }

                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1D24),
                          borderRadius:
                              BorderRadius.circular(24),
                        ),

                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,

                          children: [

                            // PRODUCT DETAILS
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    product.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    "Stock: ${product.stock}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // BADGE
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: badgeColor.withValues(alpha: 0.15),
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: Text(
                                badgeText,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: badgeColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ));
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}