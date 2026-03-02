import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'orders_controller.dart';

class CreateOrderScreen extends StatelessWidget {
  const CreateOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersController>();
    final nameController = TextEditingController();
    final amountController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Order"),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(
                hintText: "Customer Name",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  const InputDecoration(
                hintText: "Amount",
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                controller.addOrder(
                  nameController.text,
                  int.parse(amountController.text),
                );
                Get.back();
              },
              child: const Text("Create"),
            ),
          ],
        ),
      ),
    );
  }
}