import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/utils/no_internet_widget.dart';
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
            colors: [
              Color(0xFF0B1220),
              Color(0xFF0F172A),
              Color(0xFF020617),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),

            child: RefreshIndicator(
              color: Colors.white,
              backgroundColor: Colors.transparent,
              onRefresh: controller.refreshProducts,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Text(
                  "Inventory",
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Manage your products",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha:0.6),
                  ),
                ),

                const SizedBox(height: 24),

                /// KPI
                Row(
                  children: [
                    Expanded(child: _kpi("Total", controller.products.length.toString(), Colors.blue)),
                    const SizedBox(width: 10),
                    Expanded(child: _kpi("Low", controller.lowStockCount.toString(), Colors.orange)),
                    const SizedBox(width: 10),
                    Expanded(child: _kpi("Critical", controller.criticalStockCount.toString(), Colors.red)),
                  ],
                ),

                const SizedBox(height: 20),

                /// 🔥 NEW SEARCH (CLEAN + PREMIUM)
                Obx(() {
                  return Container(
                    height: 54,
                    padding: const EdgeInsets.symmetric(horizontal: 16),

                    decoration: BoxDecoration(
                      color: const Color(0xFF111827), // clean solid bg
                      borderRadius: BorderRadius.circular(16),

                      border: Border.all(
                        color: controller.searchQuery.value.isNotEmpty
                            ? Colors.white.withValues(alpha:0.25)
                            : Colors.white.withValues(alpha:0.08),
                      ),
                    ),

                    child: Row(
                      children: [

                        Icon(Icons.search,
                            color: Colors.white.withValues(alpha:0.6)),

                        const SizedBox(width: 10),

                        Expanded(
                          child: TextField(
                            onChanged: controller.searchProducts,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Search products...",
                              hintStyle: TextStyle(
                                color: Colors.white.withValues(alpha:0.4),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        if (controller.searchQuery.value.isNotEmpty)
                          GestureDetector(
                            onTap: () => controller.searchProducts(""),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha:0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 16),

                /// FILTERS (UNCHANGED)
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _chip("All", 0, controller),
                      _chip("Low", 1, controller),
                      _chip("Critical", 2, controller),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// PRODUCT LIST
                Expanded(
                  child: Obx(() {
                      if (controller.isLoading.value &&
                          controller.products.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.errorMessage.value ==
                          "No internet connection") {
                        return NoInternetWidget(
                            onRetry: controller.fetchProducts);
                      }

                      final items = controller.filteredProducts;

                      return ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 16),
                        itemBuilder: (_, i) {
                          final p = items[i];

                          final Color color = p.stock > 10
                              ? Colors.green
                              : p.stock > 3
                                  ? Colors.orange
                                  : Colors.red;

                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),

                              ///  REDUCED GRADIENT 
                              gradient: LinearGradient(
                                colors: [
                                  color.withValues(alpha:0.12), // reduced
                                  Colors.transparent,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),

                              border: Border.all(
                                color: color.withValues(alpha:0.3),
                              ),
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
                                  errorBuilder: (_, __, ___) {
                                    return Container(
                                      height: 60,
                                      width: 60,
                                      color: Colors.black26,
                                      child: const Icon(Icons.image,
                                          color: Colors.white),
                                    );
                                  },
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
                                      overflow:
                                          TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      "Stock: ${p.stock}",
                                      style: TextStyle(
                                        color: Colors.white
                                            .withValues(alpha:0.6),
                                        fontSize: 12,
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
                      },
                    );
                  }),
                ),
            ]),
            ),
          ),
        ),
      ),
    );
  }

  /// KPI (UNCHANGED STYLE)
  Widget _kpi(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 4),
          Text(title,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 11)),
        ],
      ),
    );
  }

  Widget _chip(
      String text, int index, InventoryController controller) {

    return Obx(() {
      final isSelected = controller.selectedFilter.value == index;

      return GestureDetector(
        onTap: () => controller.changeFilter(index),

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(right: 10),
          padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 8),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: isSelected
                ? Colors.white
                : Colors.white.withOpacity(0.05),
          ),

          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      );
    });
  }
}