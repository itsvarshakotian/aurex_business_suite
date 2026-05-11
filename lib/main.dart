import 'package:aurex_business_suite/features/profile/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'core/resources/color_resources.dart';
import 'core/services/auth_service.dart';
import 'core/services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  // Initialize Auth Service (GetX)
  await Get.putAsync(() => AuthService().init());
  runApp(const AurexApp());
}

class AurexApp extends StatelessWidget {
  const AurexApp({super.key});

  @override
  Widget build(BuildContext context) {

    /// INIT CONTROLLER ONCE
    Get.put<SettingsController>(SettingsController(), permanent: true);
    final settings = Get.find<SettingsController>();


    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aurex Business Suite',

        ///  FIXED HERE
        themeMode: settings.themeMode.value,

        /// LIGHT THEME
        theme: ThemeData.light(),

        /// DARK THEME (YOUR DESIGN)
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,

        //Background
        scaffoldBackgroundColor: ColorResources.primaryBackground,

        // Color
        colorScheme: const ColorScheme.dark(
          primary: ColorResources.goldPrimary,
          secondary: ColorResources.accentPurple,
          surface: ColorResources.secondaryBackground,
          error: ColorResources.error,
        ),

        // APP BAR
        appBarTheme: const AppBarTheme(
          backgroundColor: ColorResources.primaryBackground,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: ColorResources.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(
            color: ColorResources.textPrimary,
          ),
        ),

        //  TEXT
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: ColorResources.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: ColorResources.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            color: ColorResources.textSecondary,
            fontSize: 14,
          ),
          bodyMedium: TextStyle(
            color: ColorResources.textSecondary,
            fontSize: 13,
          ),
        ),

        //  CARD
     cardTheme: CardThemeData(
  color: ColorResources.secondaryBackground,
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: const BorderSide(
      color: ColorResources.borderLight,
    ),
  ),
),

        // INPUT FIELD 
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: ColorResources.surface,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: ColorResources.borderLight,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: ColorResources.borderLight,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: ColorResources.borderActive,
              width: 1.5,
            ),
          ),

          hintStyle: const TextStyle(
            color: ColorResources.textTertiary,
          ),
        ),

        //  BUTTON 
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorResources.goldPrimary,
            foregroundColor: Colors.black,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),

        //  DIVIDER 
        dividerColor: ColorResources.borderLight,
      ),

      // ROUTING 
      initialRoute: AppRoutes.splash,

      // GetX Routes
      getPages: AppPages.routes,

        defaultTransition: Transition.fadeIn,
        transitionDuration:
            const Duration(milliseconds: 300),
      );
    });
  }
}