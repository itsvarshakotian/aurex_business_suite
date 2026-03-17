import 'package:get/get.dart';
import '../../core/services/auth_service.dart';

class ProfileController extends GetxController {
  final AuthService auth = Get.find<AuthService>();

  String get role => auth.role.value;

  void logout() {
    auth.logout();
  }
}