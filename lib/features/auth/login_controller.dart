import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/auth_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../core/services/storage_service.dart';
import '../../core/resources/constants.dart';
import '../../app/routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthRepository _repository = AuthRepository();
  final StorageService _storageService = StorageService();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString selectedRole = "Admin".obs;

  void login() async {

    log("========== LOGIN FUNCTION STARTED ==========");

    log("Username entered: ${usernameController.text}");
    log("Password entered: ${passwordController.text}");
    log("Selected Role: ${selectedRole.value}");

    if (usernameController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {

      log("Validation failed: username or password empty");

      Get.snackbar(
        "Validation Error",
        "Username and password are required",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {

      log("Calling login API...");
      isLoading.value = true;

      final user = await _repository.login(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );

      log("Login API Success");
      log("Received Token: ${user.accessToken}");

      await _storageService.saveData(
        AppConstants.tokenKey,
        user.accessToken,
      );

      log("Token saved in storage");

      await _storageService.saveData(
        AppConstants.roleKey,
        selectedRole.value,
      );
      Get.find<AuthService>().role.value = selectedRole.value;

      log("Role saved: ${selectedRole.value}");

      log("Navigating to Dashboard");

      Get.offAllNamed(AppRoutes.dashboard);

      log("========== LOGIN SUCCESS ==========");

    } catch (e) {

      log("Login API Error: $e");

      Get.snackbar(
        "Login Failed",
        e.toString().replaceAll("Exception: ", ""),
        snackPosition: SnackPosition.BOTTOM,
      );

    } finally {

      isLoading.value = false;
      log("Loading stopped");

    }
  }

  @override
  void onClose() {

    log("Disposing controllers");

    usernameController.dispose();
    passwordController.dispose();

    super.onClose();
  }
}