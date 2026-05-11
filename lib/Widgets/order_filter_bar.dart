import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../features/orders/orders_controller.dart';

class OrderFilterBar extends StatelessWidget {
  const OrderFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersController>();

    final statuses = [
      {"label": "All", "value": "all"},
      {"label": "Pending", "value": "pending"},
      {"label": "Processing", "value": "processing"},
      {"label": "Shipped", "value": "shipped"},
      {"label": "Delivered", "value": "delivered"},
    ];

    /// 🔥 ONLY wrap SMALL PART in Obx
    return SizedBox(
      height: 44,
      child: Obx(() {
        final selected = controller.selectedStatus.value;

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: statuses.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final item = statuses[index];
            final isSelected = selected == item["value"];

            return GestureDetector(
              onTap: () =>
                  controller.updateStatusFilter(item["value"]!),

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 10),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: isSelected
                      ? const Color(0xFF6C5CE7)
                      : Colors.white.withOpacity(0.05),
                ),

                child: Text(
                  item["label"]!,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color:
                        isSelected ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}