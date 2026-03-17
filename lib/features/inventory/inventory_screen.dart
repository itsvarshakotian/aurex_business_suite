import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/auth_service.dart';
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

        /// Only Admin can add product
        floatingActionButton: auth.isAdmin
            ? FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {},
                child: const Icon(Icons.add,
                    color: Colors.black),
              )
            : null,

        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                "Inventory",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 24),

              ///  ONE Obx only
              Obx(() {

                if (controller.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Center(
                      child:
                          CircularProgressIndicator(),
                    ),
                  );
                }

                if (controller
                    .errorMessage.value
                    .isNotEmpty) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(
                            top: 100),
                    child: Center(
                      child: Text(
                        controller
                            .errorMessage.value,
                        style: const TextStyle(
                            color: Colors.red),
                      ),
                    ),
                  );
                }

                final items =
                    controller.filteredProducts;

                return ListView.separated(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder:
                      (_, __) =>
                          const SizedBox(
                              height: 16),
                  itemBuilder:
                      (context, index) {
                    final product =
                        items[index];

                    Color badgeColor;
                    String badgeText;

                    if (product.stock >
                        10) {
                      badgeColor =
                          Colors.green;
                      badgeText =
                          "In Stock";
                    } else if (product
                            .stock >
                        3) {
                      badgeColor =
                          Colors.orange;
                      badgeText =
                          "Low Stock";
                    } else {
                      badgeColor =
                          Colors.red;
                      badgeText =
                          "Critical";
                    }

                    return Container(
                      padding:
                          const EdgeInsets
                              .all(20),
                      decoration:
                          BoxDecoration(
                        color:
                            const Color(
                                0xFF1A1D24),
                        borderRadius:
                            BorderRadius
                                .circular(
                                    24),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          Expanded(
                         child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                product.title,
                                maxLines: product.title.length > 25 ? 2 : 1,
                                overflow: TextOverflow.visible,
                                style:const TextStyle(
                                  fontSize:14,
                                  fontWeight:FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                  height: 6),
                              Text(
                                "Stock: ${product.stock}",
                                style:
                                    const TextStyle(
                                  fontSize:
                                      13,
                                  color: Colors
                                      .grey,
                                ),
                              ),
                            ],
                          ),
                          ),

                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal:14,vertical:6),
                            decoration:
                                BoxDecoration(
                              color: badgeColor.withValues(alpha: 0.15),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          20),
                            ),
                            child: Text(
                              badgeText,
                              style:TextStyle(
                                fontSize:12,
                                fontWeight:FontWeight.w500,
                                color:badgeColor,
                              ),
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