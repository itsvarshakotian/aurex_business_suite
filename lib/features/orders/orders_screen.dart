import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/routes/app_routes.dart';
import '../../core/resources/color_resources.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/no_internet_widget.dart';
import '../../helper/helper.dart';
import 'orders_controller.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersController>();
    final auth = Get.find<AuthService>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        /// ➕ BUTTON
        floatingActionButton: auth.canCreateOrder
    ? FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          await Get.toNamed(AppRoutes.createOrder);
          controller.fetchOrders();
        },
        child: const Icon(Icons.add, color: Colors.black),
      )
    : null,

        body: Obx(() {
          // LOADING
          if (controller.isLoading.value &&
              controller.orders.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          ///  NO INTERNET
          if (controller.errorMessage.value ==
              "No internet connection") {
            return NoInternetWidget(
              onRetry: controller.fetchOrders,
            );
          }

          /// 📭 EMPTY
          if (controller.orders.isEmpty) {
            return const Center(
              child: Text(
                "No orders found",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.fetchOrders(),

            child: ListView.builder(
              controller: controller.scrollController,
              padding: const EdgeInsets.all(24),
              itemCount: controller.orders.length + 1,

              itemBuilder: (context, index) {

                /// 🔥 PAGINATION LOADER
                if (index == controller.orders.length) {
                  return Obx(() {
                    return controller.isMoreLoading.value
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : const SizedBox();
                  });
                }

                final order = controller.orders[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// 🔥 HEADER
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
                          ],
                        ),
                      ),

                    /// 🔥 ORDER CARD
                    GestureDetector(
                      onTap: () {
                        Get.to(() =>
                            CreateOrderScreen(order: order));
                      },

                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(18),

                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1D24),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // TOP ROW
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Order #${order.id}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),

                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: SnackbarHelper.getStatusColor(order.status).withValues(alpha: 0.15),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        order.status.toUpperCase(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: SnackbarHelper
                                              .getStatusColor(order.status),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            /// ITEMS
                            Row(
                              children: [
                                const Icon(Icons.shopping_bag,
                                    size: 18,
                                    color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  "${order.products.length} items",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: ColorResources.textSecondary,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            /// TOTAL
                            Row(
                              children: [
                                const Icon(
                                  Icons.currency_rupee,
                                  size: 18,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  order.total.toStringAsFixed(0),
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            /// DIVIDER
                            Container(
                              height: 1,
                              color: Colors.white.withValues(alpha: 0.05),
                            ),

                            const SizedBox(height: 10),

                            /// PRODUCT PREVIEW
                            Text(
                              order.products.isNotEmpty
                                  ? order.products.first.title
                                  : "No items",                                 
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),

///  UPDATE STATUS BUTTON
if (auth.canCreateOrder &&
    SnackbarHelper.getNextStatuses(order.status).isNotEmpty)
  Align(
    alignment: Alignment.centerRight,
    child: GestureDetector(
      onTap: () async {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1A1D24),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// TITLE
            Text(
              "Select New Status",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            /// OPTIONS
           ...SnackbarHelper.getNextStatuses(order.status)
    .map((status) {
             return ListTile(
  leading: CircleAvatar(
    radius: 14,
    backgroundColor: SnackbarHelper.getStatusColor(status)
        .withOpacity(0.15),
    child: Icon(
      Icons.circle,
      size: 12,
      color: SnackbarHelper.getStatusColor(status),
    ),
  ),

  title: Text(
    status.capitalizeFirst ?? status,
    style: GoogleFonts.poppins(
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
  ),

 onTap: () async {
  try {
    await controller.updateOrderStatus(order.id, status);

    SnackbarHelper.showSuccess(
      "Order #${order.id} updated to ${status.capitalizeFirst}",
    );

    Get.back();
  } catch (e) {
    SnackbarHelper.showError("Failed to update status");
  }
},
);
            }).toList(),

          ],
        ),
      );
    },
  );
},
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "Update Status",
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
      ),
    ),
  ),
                          ],
                        ),
                      ),
                    ),
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