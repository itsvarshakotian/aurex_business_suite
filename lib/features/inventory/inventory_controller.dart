import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../core/utils/connectivity_service.dart';

class InventoryController extends GetxController {

  final InventoryRepository repo = InventoryRepository();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = "".obs;

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final int limit = 10;
  int skip = 0;

  final RxBool isMoreLoading = false.obs;
  final RxBool hasMore = true.obs;

  List<ProductModel> get filteredProducts => products;
  
final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();

     scrollController.addListener(() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 100 &&
        !isMoreLoading.value &&
        hasMore.value) {

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
    } else {
      isLoading.value = true;
      errorMessage.value = "";

      skip = 0;
      products.clear();
      hasMore.value = true;
    }

    final data = await repo.fetchProducts(
      limit: limit,
      skip: skip,
    );

    if (data.length < limit) {
      hasMore.value = false;
    }

    products.addAll(data);
    skip += limit;

  } catch (e) {

    // HANDLE DIO INTERNET ERROR ALSO
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
}