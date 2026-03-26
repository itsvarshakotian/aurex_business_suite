import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/orders_repository.dart';

class OrdersController extends GetxController {
  

  final RxList<OrderModel> orders = <OrderModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = "".obs;
  final OrdersRepository repo = OrdersRepository();

  final int limit = 10;
  int skip = 0;

  final RxBool isMoreLoading = false.obs;
  final RxBool hasMore = true.obs;

  final ScrollController scrollController = ScrollController();
  final RxList<OrderModel> localOrders = <OrderModel>[].obs;

  DateTime? lastCacheTime;

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
    // CLEAR CACHE AFTER 30 MIN
if (lastCacheTime != null &&
    DateTime.now().difference(lastCacheTime!).inMinutes > 30) {
  localOrders.clear();
}
  try {
    if (isLoadMore) {
      isMoreLoading.value = true;
    } else {
      isLoading.value = true;
      errorMessage.value = "";

      skip = 0;

      hasMore.value = true;
    }

    final data = await repo.fetchOrders(
      limit: limit,
      skip: skip,
    );

    if (data.isEmpty) {
      hasMore.value = false;
    } else {

      if (!isLoadMore) {
      orders.assignAll([
  ...localOrders,
  ...data,
]);
      } else {
        orders.addAll(data);
      }

      skip += limit;
    }

  } catch (e) {
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

      final newOrder = await repo.createOrder();

      orders.insert(0, newOrder);
      localOrders.insert(0, newOrder);


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
  Future<void> updateOrderStatus(
    int orderId, String newStatus) async {
  try {
    final index =
        orders.indexWhere((order) => order.id == orderId);

    if (index == -1) return;

    /// 🔥 1. UPDATE UI IMMEDIATELY
    orders[index].status = newStatus.toLowerCase();
    orders.refresh();

    /// 🔥 ALSO update local cache
    final localIndex =
        localOrders.indexWhere((o) => o.id == orderId);

    if (localIndex != -1) {
      localOrders[localIndex].status = newStatus.toLowerCase();
    }

    /// 🔥 2. CALL API IN BACKGROUND
    await repo.updateOrderStatus(
      orderId: orderId,
      status: newStatus,
    );

  } catch (e) {
    /// ❗ OPTIONAL: rollback if API fails
    print("API failed: $e");
  }
}
}