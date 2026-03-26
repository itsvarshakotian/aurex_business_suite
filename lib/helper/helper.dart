import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarHelper {

  /// SUCCESS
  static void showSuccess(String message) {
    Get.snackbar(
      "Success",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  /// ERROR
  static void showError(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  /// INFO
  static void showInfo(String message) {
    Get.snackbar(
      "Info",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }
  static Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case "pending":
      return Colors.orange;
    case "processing":
      return Colors.blue;
    case "shipped":
      return Colors.purple;
    case "delivered":
      return Colors.green;
    case "cancelled":
      return Colors.red;
    default:
      return Colors.grey;
  }
}
static List<String> getNextStatuses(String currentStatus) {
  switch (currentStatus.toLowerCase()) {
    case "pending":
      return ["processing", "cancelled"];
    case "processing":
      return ["shipped", "cancelled"];
    case "shipped":
      return ["delivered"];
    case "delivered":
      return [];
    default:
      return [];
  }
}
}