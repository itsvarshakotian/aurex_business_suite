import 'package:get/get.dart';

class InventoryController extends GetxController {
  final RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;
  final RxString searchQuery = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  void loadProducts() {
    products.value = [
      {"name": "MacBook Pro", "stock": 25},
      {"name": "iPhone 15", "stock": 5},
      {"name": "AirPods Pro", "stock": 2},
      {"name": "iPad Air", "stock": 15},
    ];
  }

  List<Map<String, dynamic>> get filteredProducts {
    if (searchQuery.value.isEmpty) return products;
    return products
        .where((p) =>
            p["name"]
                .toString()
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()))
        .toList();
  }
}