import 'package:flutter/material.dart' show ThemeMode;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final RxBool isDarkMode = true.obs;
  final RxBool notificationsEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool("dark_mode") ?? true;
    notificationsEnabled.value =
        prefs.getBool("notifications") ?? true;
  }

  Future<void> toggleTheme(bool value) async {
    isDarkMode.value = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("dark_mode", value);

    Get.changeThemeMode(
        value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleNotifications(bool value) async {
    notificationsEnabled.value = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("notifications", value);
  }
}