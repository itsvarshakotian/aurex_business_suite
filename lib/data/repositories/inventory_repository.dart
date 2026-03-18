import 'dart:developer';
import 'package:dio/dio.dart';
import '../models/product_model.dart';

class InventoryRepository {
  final Dio _dio = Dio();

  Future<List<ProductModel>> fetchProducts({
  int limit = 10,
  int skip = 0,
}) async {
  try {
    final response = await _dio.get(
      "https://dummyjson.com/products",
      queryParameters: {
        "limit": limit,
        "skip": skip,
      },
    );

    if (response.statusCode == 200) {
      final List products = response.data['products'];

      return products
          .map((e) => ProductModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Status code: ${response.statusCode}");
    }

  } catch (e) {
    throw Exception("Failed to load products: $e");
  }
}
}