import 'dart:async';
import 'package:get/get.dart';
import '../../core/services/storage_service.dart';
import '../../core/resources/constants.dart';
import '../../app/routes/app_routes.dart';

class SplashController extends GetxController {
  final StorageService _storageService = StorageService();

  @override
  void onInit() {
    super.onInit();
    _startApp();
  }

  void _startApp() async {
    await Future.delayed(const Duration(seconds: 3));

    final token = await _storageService.getData(AppConstants.tokenKey);

    if (token != null && token.isNotEmpty) {
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}