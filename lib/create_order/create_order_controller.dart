import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../features/orders/orders_controller.dart';
import '../data/models/order_model.dart';

class CreateOrderController extends GetxController {
  final InventoryRepository repo = InventoryRepository();

  final RxBool isLoading = false.obs;
  final RxBool isMoreLoading = false.obs;
  final RxBool hasMore = true.obs;

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<ProductModel> filteredProducts = <ProductModel>[].obs;

  final RxString searchQuery = "".obs;

  final int limit = 10;
  int skip = 0;

  final ScrollController scrollController = ScrollController();

  // productId -> quantity
  final RxMap<int, int> selectedProducts = <int, int>{}.obs;
  final RxDouble totalPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();

    // SCROLL LISTENER (PAGINATION)
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !isMoreLoading.value &&
          hasMore.value &&
          !isLoading.value) {
        fetchProducts(isLoadMore: true);
      }
    });
  }

  // FETCH PRODUCTS WITH PAGINATION
  Future<void> fetchProducts({bool isLoadMore = false}) async {
    try {
      if (isLoadMore) {
        isMoreLoading.value = true;
      } else {
        isLoading.value = true;

        skip = 0;
        products.clear();
        filteredProducts.clear();
        hasMore.value = true;
      }

      final data = await repo.fetchProducts(
        limit: limit,
        skip: skip,
      );

      if (data.isEmpty) {
        hasMore.value = false;
      } else {
        products.addAll(data);

        /// IMPORTANT
        applySearch();

        skip += limit;
      }
    } catch (e) {
      log("Pagination error: $e");
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  // SEARCH
  void searchProducts(String query) {
    searchQuery.value = query;
    applySearch();
  }

  void applySearch() {
    if (searchQuery.value.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products.where((p) => p.title
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase())),
      );
    }
  }

  // INCREASE
  void increaseQty(int productId) {
    selectedProducts[productId] =
        (selectedProducts[productId] ?? 0) + 1;

    calculateTotal();
  }

  // DECREASE
  void decreaseQty(int productId) {
    if (!selectedProducts.containsKey(productId)) return;

    if (selectedProducts[productId]! > 1) {
      selectedProducts[productId] =
          selectedProducts[productId]! - 1;
    } else {
      selectedProducts.remove(productId);
    }

    calculateTotal();
  }

  // TOTAL
  void calculateTotal() {
    double total = 0;

    for (var entry in selectedProducts.entries) {
      final product = products.firstWhere(
        (p) => p.id == entry.key,
      );

      total += product.price * entry.value;
    }

    totalPrice.value = total;
  }

  // PLACE ORDER
  void placeOrder() {
    try {
      if (selectedProducts.isEmpty) {
        Get.snackbar("Error", "No products selected");
        return;
      }

      final ordersController = Get.find<OrdersController>();

      ///  CONVERT CART → PRODUCTS LIST
      final orderProducts = selectedProducts.entries.map((entry) {
        final product =
            products.firstWhere((p) => p.id == entry.key);

        return OrderProductModel(
          id: product.id,
          title: product.title,
          price: product.price,
          quantity: entry.value,
          total: product.price * entry.value,
          thumbnail: product.thumbnail,
        );
      }).toList();

      // CALCULATE EXTRA FIELDS
      int totalProducts = selectedProducts.length;

      int totalQuantity = selectedProducts.values.fold(
        0,
        (sum, qty) => sum + qty,
      );

      /// CREATE ORDER MODEL 
      final newOrder = OrderModel(
        id: DateTime.now().millisecondsSinceEpoch,
        products: orderProducts,

        total: totalPrice.value,
        totalProducts: totalProducts,
        totalQuantity: totalQuantity,

        date: DateTime.now(),
        status: "Pending",
      );

      /// ADD TO ORDERS SCREEN
      ordersController.localOrders.insert(0, newOrder);
      ordersController.orders.insert(0, newOrder);

      /// CLEAR CART
      selectedProducts.clear();
      totalPrice.value = 0;

      Get.back();

      Get.snackbar("Success", "Order placed successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to place order");
    }
  }
}