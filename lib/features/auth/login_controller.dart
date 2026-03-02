import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repositories/auth_repository.dart';
import '../../core/services/storage_service.dart';
import '../../core/resources/constants.dart';
import '../../app/routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthRepository _repository = AuthRepository();
  final StorageService _storageService = StorageService();

  final TextEditingController usernameController =
      TextEditingController();
  final TextEditingController passwordController =
      TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString selectedRole = "Admin".obs;

  void login() async {
    if (usernameController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Username and password are required",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final user = await _repository.login(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );

      await _storageService.saveData(
        AppConstants.tokenKey,
        user.token,
      );

      await _storageService.saveData(
        AppConstants.roleKey,
        selectedRole.value,
      );

      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      Get.snackbar(
        "Login Failed",
        e.toString().replaceAll("Exception: ", ""),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}