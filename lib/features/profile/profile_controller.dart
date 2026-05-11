import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/auth_service.dart';

class ProfileController extends GetxController {
  final AuthService auth = Get.find<AuthService>();

  final RxString profileImagePath = "".obs;
  final RxString name = "User".obs;
  final RxString role = "".obs;

  @override
  void onInit() {
    super.onInit();
    role.value = auth.role.value;
    loadProfile();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    profileImagePath.value = prefs.getString("profile_image") ?? "";
    name.value = prefs.getString("user_name") ?? "User";
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();

      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      profileImagePath.value = image.path;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("profile_image", image.path);
    } catch (e) {
      print("Image error: $e");
    }
  }

  Future<void> saveName(String newName) async {
    name.value = newName;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_name", newName);
  }

  void logout() {
    auth.logout();
  }
}
