import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/orders_repository.dart';

class OrdersController extends GetxController {
  final OrdersRepository repository = OrdersRepository();

  final RxList<OrderModel> orders = <OrderModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = "".obs;
  final OrdersRepository repo = OrdersRepository();

  final int limit = 10;
  int skip = 0;

  final RxBool isMoreLoading = false.obs;
  final RxBool hasMore = true.obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchOrders();

 scrollController.addListener(() {
  if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent &&
      !isMoreLoading.value &&
      hasMore.value &&
      !isLoading.value) {

    log(" Reached exact bottom → load more");
    fetchOrders(isLoadMore: true);
  }
});
  }

  Future<void> fetchOrders({bool isLoadMore = false}) async {
    try {

      if (isLoadMore) {
        isMoreLoading.value = true;
      } else {
        isLoading.value = true;
        errorMessage.value = "";

        skip = 0;
        orders.clear();
        hasMore.value = true;
      }

      log("Params → skip: $skip, limit: $limit");

      final data = await repo.fetchOrders(
        limit: limit,
        skip: skip,
      );



      if (data.isEmpty) {
        hasMore.value = false;
      } else {
        orders.addAll(data);
        skip += limit;

        log(" Orders added. Total Orders: ${orders.length}");

        //  Log each order (important for debugging)
        for (int i = 0; i < data.length; i++) {
          final order = data[i];

          // adjust fields based on your model
          if (order.products == null || order.products!.isEmpty) {
          } else {
            for (var product in order.products!) {
            }
          }
        }
      }

    } catch (e) {
      log("ERROR in fetchOrders: $e");
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<void> createOrder() async {
    try {

      isLoading.value = true;
      errorMessage.value = "";

      final newOrder = await repository.createOrder();

      orders.insert(0, newOrder);

      log("Order Created Successfully");
      log("New Order ID: ${newOrder.id}");
      log("Total Orders After Insert: ${orders.length}");

    } catch (e) {

      errorMessage.value =
          e.toString().replaceAll("Exception: ", "");
    } finally {
      isLoading.value = false;
    }
  }
}