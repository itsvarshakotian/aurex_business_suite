import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/resources/color_resources.dart';
import '../../data/models/order_model.dart';

class CreateOrderScreen extends StatelessWidget {
  final OrderModel order;

  const CreateOrderScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.primaryBackground,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Order Details",
          style: TextStyle(color: ColorResources.textPrimary),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 HERO CARD (NEUTRAL)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: ColorResources.secondaryBackground,
                border: Border.all(
                  color: ColorResources.borderLight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Order #${order.id}",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ColorResources.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    order.date.toString(),
                    style: TextStyle(
                      color: ColorResources.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// TOTAL (WHITE FOCUS)
                  Text(
                    "₹${order.total.toStringAsFixed(0)}",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            /// TITLE
            Text(
              "Products",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ColorResources.textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            /// PRODUCT LIST
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final product = order.products[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorResources.secondaryBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: ColorResources.borderLight,
                    ),
                  ),
                  child: Row(
                    children: [

                      /// LEFT SIDE
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              product.title,
                              style: TextStyle(
                                color: ColorResources.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "Qty: ${product.quantity}",
                              style: TextStyle(
                                color: ColorResources.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// PRICE
                      Text(
                        "₹${product.price}",
                        style: TextStyle(
                          color: ColorResources.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            /// TOTAL CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ColorResources.secondaryBackground,
                border: Border.all(
                  color: ColorResources.borderLight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text(
                    "Total Amount",
                    style: TextStyle(
                      color: ColorResources.textSecondary,
                    ),
                  ),

                  Text(
                    "₹${order.total.toStringAsFixed(0)}",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorResources.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}