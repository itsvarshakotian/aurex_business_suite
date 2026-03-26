import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../create_order/create_order_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateOrderController>();

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Cart", style: GoogleFonts.poppins()),
      ),

      body: Obx(() {

        /// 🟡 EMPTY CART
        if (controller.selectedProducts.isEmpty) {
          return const Center(
            child: Text(
              "Cart is empty",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        final items = controller.selectedProducts.entries.toList();

        return Column(
          children: [

            /// 📦 CART ITEMS
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,

                itemBuilder: (context, index) {
                  final entry = items[index];

                  final product = controller.products.firstWhere(
                    (p) => p.id == entry.key,
                  );

                  final qty = entry.value;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1D24),
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: Row(
                      children: [

                        /// 🖼 IMAGE
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade800,
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: product.thumbnail.isEmpty
                              ? const Icon(Icons.image, color: Colors.grey)
                              : Image.network(product.thumbnail, fit: BoxFit.cover),
                        ),

                        const SizedBox(width: 14),

                        /// DETAILS
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                product.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "₹${product.price}",
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// ➕➖ QTY
                        Row(
                          children: [

                            IconButton(
                              onPressed: () {
                                controller.decreaseQty(product.id);
                              },
                              icon: const Icon(Icons.remove, color: Colors.white),
                            ),

                            Text(
                              qty.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),

                            IconButton(
                              onPressed: () {
                                controller.increaseQty(product.id);
                              },
                              icon: const Icon(Icons.add, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            /// 🧾 BOTTOM BAR
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF1A1D24),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  /// TOTAL
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "₹${controller.totalPrice.value.toStringAsFixed(0)}",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  /// PLACE ORDER
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      controller.placeOrder();
                      Get.back(); // go back after placing
                    },
                    child: const Text(
                      "Place Order",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}