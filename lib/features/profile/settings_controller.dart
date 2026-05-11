import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {

  final Rx<ThemeMode> themeMode = ThemeMode.dark.obs;
  final RxBool notificationsEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final isDark = prefs.getBool("dark_mode") ?? true;

    themeMode.value =
        isDark ? ThemeMode.dark : ThemeMode.light;

    notificationsEnabled.value =
        prefs.getBool("notifications") ?? true;
  }

  Future<void> toggleTheme(bool isDark) async {
    themeMode.value =
        isDark ? ThemeMode.dark : ThemeMode.light;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("dark_mode", isDark);
  }

  Future<void> toggleNotifications(bool value) async {
    notificationsEnabled.value = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("notifications", value);
  }
}