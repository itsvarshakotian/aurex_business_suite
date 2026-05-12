import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../data/models/product_model.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../core/utils/connectivity_service.dart';

class InventoryController extends GetxController {

  final InventoryRepository repo = InventoryRepository();

  final RxBool isLoading = false.obs;
  final RxBool isMoreLoading = false.obs;
  final RxBool hasMore = true.obs;

  final RxString errorMessage = "".obs;

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<ProductModel> filteredList = <ProductModel>[].obs;

  List<ProductModel> get filteredProducts => filteredList;

  final int limit = 10;
  int skip = 0;

  final ScrollController scrollController = ScrollController();

  final RxString searchQuery = "".obs;
  final RxInt selectedFilter = 0.obs;

  @override
  void onInit() {
    super.onInit();

    fetchProducts();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !isMoreLoading.value &&
          hasMore.value) {

        log("Triggering Load More...");
        fetchProducts(isLoadMore: true);
      }
    });
  }

  Future<void> fetchProducts({bool isLoadMore = false}) async {
    try {
      final hasInternet = await ConnectivityService().hasInternet();

      if (!hasInternet) {
        errorMessage.value = "No internet connection";
        return;
      }

      if (isLoadMore) {
        isMoreLoading.value = true;
        log("Loading more... skip: $skip");
      } else {
        isLoading.value = true;
        errorMessage.value = "";

        skip = 0;
        products.clear();
        hasMore.value = true;

        log("🚀 Fresh Load Started");
      }

      final data = await repo.fetchProducts(
        limit: limit,
        skip: skip,
      );

      log("📦 API Returned Items: ${data.length}");

      if (data.length < limit) {
        hasMore.value = false;
        log(" No more data available");
      }
      products.addAll(data);
      skip += limit;

      log("Total Products Stored: ${products.length}");

      applyFilters();

    } catch (e) {

      log("ERROR: $e");

      if (e.toString().contains("SocketException")) {
        errorMessage.value = "No internet connection";
      } else {
        errorMessage.value = "Failed to load products";
      }

    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  /// Pull-to-refresh entry point
  Future<void> refreshProducts() async {
    // Reuse the existing fresh-load behavior (clears list, resets skip/hasMore)
    await fetchProducts(isLoadMore: false);
  }

  /// SEARCH
  void searchProducts(String value) {
    searchQuery.value = value;
    log("🔍 Search Query: $value");
    applyFilters();
  }

  /// FILTER CHANGE
  void changeFilter(int index) {
    selectedFilter.value = index;
    log("🎯 Filter Changed: $index");
    applyFilters();
  }

  /// FILTER LOGIC
  void applyFilters() {

    List<ProductModel> temp = products.toList();

    log("Before Filter Count: ${temp.length}");

    if (searchQuery.value.isNotEmpty) {
      temp = temp.where((p) =>
          p.title.toLowerCase().contains(
              searchQuery.value.toLowerCase())).toList();
    }

    if (selectedFilter.value == 1) {
      temp = temp.where((p) =>
          p.stock <= 10 && p.stock > 3).toList();
    } else if (selectedFilter.value == 2) {
      temp = temp.where((p) =>
          p.stock <= 3).toList();
    }

    filteredList.assignAll(temp);

    log(" After Filter Count: ${filteredList.length}");
  }

  /// KPI
  int get lowStockCount {
    final count =
        products.where((p) => p.stock <= 10 && p.stock > 3).length;
    log("Low Stock Count: $count");
    return count;
  }

  int get criticalStockCount {
    final count =
        products.where((p) => p.stock <= 3).length;
    log("Critical Stock Count: $count");
    return count;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}