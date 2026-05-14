import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/auth_service.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/auth_service.dart';

class ProfileController extends GetxController {
  final AuthService auth = Get.find<AuthService>();

  final RxMap<String, String> profileData = <String, String>{}.obs;
  final RxMap<String, String> statsData = <String, String>{}.obs;

  final RxBool notificationsEnabled = true.obs;
  final RxBool isDarkMode = true.obs;

  final RxString profileImagePath = "".obs;
  final RxString name = "User".obs;
  final RxString role = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    loadSettings();
  }

  /// 🔥 LOAD PROFILE
  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    role.value = prefs.getString("role") ?? auth.role.value;

    profileImagePath.value = prefs.getString("profile_image") ?? "";
    name.value = prefs.getString("user_name") ?? "User";

    /// ✅ ROLE BASED DATA
    if (role.value == "admin") {
      profileData.value = {
        "Email": prefs.getString("admin_email") ?? "admin@mail.com",
        "Phone": prefs.getString("admin_phone") ?? "+91 9999999999",
      };

      statsData.value = {
        "Users": "120",
        "Managers": "12",
        "Reports": "24",
        "Activity": "Active",
      };
    } else if (role.value == "manager") {
      profileData.value = {
        "Email": prefs.getString("manager_email") ?? "manager@mail.com",
        "Phone": prefs.getString("manager_phone") ?? "+91 8888888888",
      };

      statsData.value = {
        "Team": "10",
        "Projects": "4",
        "Approvals": "6",
        "Performance": "Good",
      };
    } else {
      profileData.value = {
        "Email": prefs.getString("staff_email") ?? "staff@mail.com",
        "Phone": prefs.getString("staff_phone") ?? "+91 7777777777",
      };

      statsData.value = {
        "Tasks": "12",
        "Completed": "8",
        "Hours": "6h",
        "Manager": "John",
      };
    }
  }

  /// 🔥 SETTINGS
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    notificationsEnabled.value =
        prefs.getBool("notifications") ?? true;

    isDarkMode.value = prefs.getBool("dark_mode") ?? true;
  }

  Future<void> updateNotifications(bool value) async {
    notificationsEnabled.value = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("notifications", value);
  }

  Future<void> updateTheme(bool value) async {
    isDarkMode.value = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("dark_mode", value);

    Get.changeThemeMode(
        value ? ThemeMode.dark : ThemeMode.light);
  }

  /// 🔥 IMAGE
  Future<void> pick(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);

    if (image == null) return;

    profileImagePath.value = image.path;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("profile_image", image.path);
  }

  void showImageSource() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        color: const Color(0xFF1A1D24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text("Camera",
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Get.back();
                pick(ImageSource.camera);
              },
            ),

            ListTile(
              leading: const Icon(Icons.photo, color: Colors.white),
              title: const Text("Gallery",
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Get.back();
                pick(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveName(String newName) async {
    name.value = newName;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_name", newName);
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // 🔥 fix stale data
    auth.logout();
  }
}