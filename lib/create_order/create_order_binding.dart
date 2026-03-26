import 'package:get/get.dart';
import 'create_order_controller.dart';

class CreateOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateOrderController>(
      () => CreateOrderController(),
    );
  }
}