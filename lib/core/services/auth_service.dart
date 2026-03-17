import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import 'storage_service.dart';
import '../resources/constants.dart';

class AuthService extends GetxService {
  final StorageService _storage = StorageService();

  final RxString role = "Staff".obs;

  Future<AuthService> init() async {
    final savedRole =
        await _storage.readData(AppConstants.roleKey);

    if (savedRole != null && savedRole.isNotEmpty) {
      role.value = savedRole;
    }

    return this;
  }

  bool get isAdmin => role.value == "Admin";
  bool get isManager => role.value == "Manager";
  bool get isStaff => role.value == "Staff";

Future<void> logout() async {
  final storage = StorageService();

  await storage.removeData(AppConstants.tokenKey);
  await storage.removeData(AppConstants.roleKey);

  role.value = "Staff";

  Get.offAllNamed(AppRoutes.login);
}
}