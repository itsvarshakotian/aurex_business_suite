import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/utils/no_internet_widget.dart';
import '../../core/resources/color_resources.dart';
import 'inventory_controller.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B1220), Color(0xFF0F172A), Color(0xFF020617)],
          ),
        ),

        child: SafeArea(
          child: Obx(() {
            if (controller.errorMessage.value == "No internet connection") {
              return NoInternetWidget(onRetry: controller.fetchProducts);
            }

            return RefreshIndicator(
              onRefresh: controller.fetchProducts,

              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Text(
                      "Inventory",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// KPI STRIP (PRODUCTION STYLE)
                    Obx(() {
                      return Row(
                        children: [
                          Expanded(
                            child: _kpiCard(
                              "Total",
                              controller.products.length.toString(),
                              Icons.inventory_2_outlined,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _kpiCard(
                              "Low",
                              controller.lowStockCount.toString(),
                              Icons.warning_amber_rounded,
                              Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _kpiCard(
                              "Critical",
                              controller.criticalStockCount.toString(),
                              Icons.error_outline,
                              Colors.red,
                            ),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 28),

                    /// SEARCH
                    Container(
                      height: 55,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white.withOpacity(0.05),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.white.withOpacity(0.6),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              onChanged: controller.searchProducts,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: "Search products...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// FILTER CHIPS
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _chip(context,"All", 0, controller),
                          _chip(context,"Low", 1, controller),
                          _chip(context,"Critical", 2, controller),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    ///  PRODUCT LIST
                    Obx(() {
                      if (controller.isLoading.value &&
                          controller.products.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final items = controller.filteredProducts;

                      /// EMPTY STATE
                      if (items.isEmpty) {
                        return SizedBox(
                          height:
                              MediaQuery.of(context).size.height *
                              0.6,

                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 60,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "No products found",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  controller.selectedFilter.value == 2
                                      ? "No critical stock items"
                                      : controller.selectedFilter.value == 1
                                      ? "No low stock items"
                                      : "Try adjusting your search",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.4),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      /// 🔥 IMPORTANT: RETURN LIST ALSO
                      return Column(
                        children: items.map((p) {
                          final color = p.stock > 10
                              ? Colors.green
                              : p.stock > 3
                              ? Colors.orange
                              : Colors.red;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(14),

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.white.withOpacity(0.04),
                              border: Border.all(color: color.withOpacity(0.3)),
                            ),

                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    p.thumbnail ?? "",
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      Text(
                                        "Stock: ${p.stock}",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  /// 🔥 KPI CARD
  Widget _kpiCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 FILTER CHIP
  Widget _chip(BuildContext context,String text, int index, InventoryController controller) {
    return Obx(() {
      final isSelected = controller.selectedFilter.value == index;

      return GestureDetector(
        onTap: () => controller.changeFilter(index),
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: isSelected
                ? ColorResources.profileCircle(context)
                : Colors.white.withOpacity(0.05),
          ),
          child: Text(
            text,
            style: TextStyle(color: isSelected ? Colors.black : Colors.white),
          ),
        ),
      );
    });
  }
}
