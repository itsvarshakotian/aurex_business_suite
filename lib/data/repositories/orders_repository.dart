import 'package:dio/dio.dart';

import '../../core/services/dio_service.dart';
import '../../core/resources/url_resources.dart';
import '../models/order_model.dart';

class OrdersRepository {
  final Dio dio = DioService().dio;

  Future<List<OrderModel>> fetchOrders({
  int limit = 10,
  int skip = 0,
}) async {
  try {
    final response = await Dio().get(
      "https://dummyjson.com/carts",
      queryParameters: {
        "limit": limit,
        "skip": skip,
      },
    );

    if (response.statusCode == 200) {
      final List carts = response.data['carts'];

      return carts
          .map((e) => OrderModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Failed to load orders: $e");
  }
  }
  Future<OrderModel> createOrder() async {
  try {
    final response = await dio.post(
      UrlResources.addCart,
      data: {
        "userId": 1,
        "products": [
          {
            "id": 1,
            "quantity": 1,
          }
        ]
      },
    );

    return OrderModel.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(
      e.response?.data["message"] ??
          "Failed to create order",
    );
  }
}
}