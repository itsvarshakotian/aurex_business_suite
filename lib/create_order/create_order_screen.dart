import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../cart/cart_screen.dart';
import 'create_order_controller.dart';
import 'product_detail_screen.dart';

class CreateOrderScreen extends StatelessWidget {
  const CreateOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateOrderController>();

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Create Order",
          style: GoogleFonts.poppins(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
  backgroundColor: Colors.white,
  onPressed: () {
    Get.to(() => const CartScreen());
  },
  child: const Icon(Icons.shopping_cart, color: Colors.black),
),

      body: Column(
        children: [

          //  SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: controller.searchProducts,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search products...",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1A1D24),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          ///  GRID
          Expanded(
            child: Obx(() {

              if (controller.isLoading.value &&
                  controller.filteredProducts.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.filteredProducts.isEmpty) {
                return const Center(
                  child: Text(
                    "No products found",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return GridView.builder(
                controller: controller.scrollController,

                padding: const EdgeInsets.symmetric(horizontal: 16),

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.55, 
                ),

                itemCount: controller.filteredProducts.length +
                    (controller.isMoreLoading.value ? 1 : 0),

                itemBuilder: (context, index) {

                  if (index == controller.filteredProducts.length) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final product =
                      controller.filteredProducts[index];

                  return Obx(() {
                    final qty =
                        controller.selectedProducts[product.id] ?? 0;

                        return GestureDetector(
                   onTap: () {
                    Get.to(() => ProductDetailScreen(product: product));
                  },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1D24),
                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          // BIG IMAGE
                          SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(14),
                                color: Colors.grey.shade800,
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: product.thumbnail.isEmpty
                                  ? const Icon(Icons.image,
                                      color: Colors.grey)
                                  : Image.network(
                                      product.thumbnail,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // TITLE
                          Text(
                            product.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 4),

                           /// DESCRIPTION (NEW)
                            Text(
                               product.description ?? "",
                               maxLines: 2,
                               overflow: TextOverflow.ellipsis,
                               style: GoogleFonts.poppins(
                               color: Colors.grey,
                               fontSize: 11,
                              ),
                          ),

                    const SizedBox(height: 6),

                          // PRICE
                          Text(
                            "₹${product.price}",
                            style: GoogleFonts.poppins(
                              color: Colors.greenAccent,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// QTY CONTROL
                          // Container(
                          //   decoration: BoxDecoration(
                          //     color: Colors.black,
                          //     borderRadius:
                          //         BorderRadius.circular(10),
                          //   ),
                          //   child: Row(
                          //     mainAxisAlignment:
                          //         MainAxisAlignment.spaceBetween,
                          //     children: [

                          //       IconButton(
                          //         onPressed: () {
                          //           controller.decreaseQty(product.id);
                          //         },
                          //         icon: const Icon(Icons.remove,
                          //             size: 18,
                          //             color: Colors.white),
                          //       ),

                          //       Text(
                          //         qty.toString(),
                          //         style: const TextStyle(
                          //             color: Colors.white),
                          //       ),

                          //       IconButton(
                          //         onPressed: () {
                          //           controller.increaseQty(product.id);
                          //         },
                          //         icon: const Icon(Icons.add,
                          //             size: 18,
                          //             color: Colors.white),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ));
                  });
                },
              );
            }),
          ),

          ///  BOTTOM BAR
          // Obx(() {
          //   return Container(
          //     padding: const EdgeInsets.all(16),
          //     decoration: const BoxDecoration(
          //       color: Color(0xFF1A1D24),
          //       borderRadius: BorderRadius.vertical(
          //         top: Radius.circular(24),
          //       ),
          //     ),
          //     child: Row(
          //       mainAxisAlignment:
          //           MainAxisAlignment.spaceBetween,
          //       children: [

          //         Column(
          //           crossAxisAlignment:
          //               CrossAxisAlignment.start,
          //           children: [
          //             const Text(
          //               "Total",
          //               style: TextStyle(
          //                   color: Colors.grey,
          //                   fontSize: 12),
          //             ),
          //             Text(
          //               "₹${controller.totalPrice.value.toStringAsFixed(0)}",
          //               style: GoogleFonts.poppins(
          //                 color: Colors.white,
          //                 fontSize: 18,
          //                 fontWeight: FontWeight.w600,
          //               ),
          //             ),
          //           ],
          //         ),

          //         ElevatedButton(
          //           style: ElevatedButton.styleFrom(
          //             backgroundColor: Colors.white,
          //             padding: const EdgeInsets.symmetric(
          //                 horizontal: 24, vertical: 14),
          //             shape: RoundedRectangleBorder(
          //               borderRadius:
          //                   BorderRadius.circular(14),
          //             ),
          //           ),
          //           onPressed: controller.placeOrder,
          //           child: const Text(
          //             "Place Order",
          //             style: TextStyle(color: Colors.black),
          //           ),
          //         ),
          //       ],
          //     ),
          //   );
          // }),
        ],
      ),
    );
  }
}