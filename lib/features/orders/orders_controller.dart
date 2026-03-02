import 'package:get/get.dart';

class OrdersController extends GetxController {
  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  void loadOrders() {
    orders.value = [
      {
        "id": "#AUR001",
        "customer": "John Doe",
        "amount": 1200,
        "status": "Pending",
      },
      {
        "id": "#AUR002",
        "customer": "Sarah Smith",
        "amount": 5400,
        "status": "Completed",
      },
    ];
  }

  void addOrder(String customer, int amount) {
    orders.insert(0, {
      "id": "#AUR00${orders.length + 1}",
      "customer": customer,
      "amount": amount,
      "status": "Pending",
    });
  }

  void updateStatus(int index, String newStatus) {
    orders[index]["status"] = newStatus;
    orders.refresh();
  }
}