import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'core/resources/color_resources.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AurexApp());
}

class AurexApp extends StatelessWidget {
  const AurexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aurex Business Suite',

      // Premium Dark Theme
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ColorResources.background,
      ),

      // Initial Route
      initialRoute: AppRoutes.splash,

      // GetX Routes
      getPages: AppPages.routes,

      // Smooth transition
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}