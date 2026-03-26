import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/product_model.dart';
import '../create_order/create_order_controller.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateOrderController>();

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Product Details",
          style: GoogleFonts.poppins(),
        ),
      ),

      body: Column(
        children: [

          /// 🖼 IMAGE
          Container(
            height: 220,
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade800,
            ),
            clipBehavior: Clip.hardEdge,
            child: product.thumbnail.isEmpty
                ? const Icon(Icons.image, color: Colors.grey)
                : Image.network(
                    product.thumbnail,
                    fit: BoxFit.cover,
                  ),
          ),

          /// 📄 DETAILS
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// TITLE
                  Text(
                    product.title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// DESCRIPTION
                  Text(
                    product.description ?? "No description",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// PRICE
                  Text(
                    "₹${product.price}",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.greenAccent,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// STOCK STATUS
                  Builder(
                    builder: (_) {
                      Color color;
                      String text;

                      if (product.stock > 10) {
                        color = Colors.green;
                        text = "In Stock";
                      } else if (product.stock > 3) {
                        color = Colors.orange;
                        text = "Low Stock";
                      } else {
                        color = Colors.red;
                        text = "Critical Stock";
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "$text (${product.stock})",
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(),

                  /// 🔢 QTY + BUTTON
                  Obx(() {
                    final qty =
                        controller.selectedProducts[product.id] ?? 0;

                    return Column(
                      children: [

                        /// QTY SELECTOR
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [

                            Text(
                              "Quantity",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),

                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1D24),
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [

                                  IconButton(
                                    onPressed: () {
                                      controller.decreaseQty(
                                          product.id);
                                    },
                                    icon: const Icon(Icons.remove,
                                        color: Colors.white),
                                  ),

                                  Text(
                                    qty.toString(),
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),

                                  IconButton(
                                    onPressed: () {
                                      controller.increaseQty(
                                          product.id);
                                    },
                                    icon: const Icon(Icons.add,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        /// ADD BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(
                                      vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () {
                              if (qty == 0) {
                                Get.snackbar(
                                  "Error",
                                  "Select quantity first",
                                );
                                return;
                              }

                              Get.back(); // go back to grid
                            },
                            child: const Text(
                              "Add to Cart",
                              style:
                                  TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}