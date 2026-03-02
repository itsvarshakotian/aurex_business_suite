import 'package:get/get.dart';
import '../../features/navigation/main_navigation_binding.dart';
import '../../features/navigation/main_navigation_screen.dart';
import 'app_routes.dart';

import '../../features/splash/splash_screen.dart';
import '../../features/splash/splash_binding.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/login_binding.dart';

class AppPages {
  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
  name: AppRoutes.dashboard,
  page: () => const MainNavigationScreen(),
  binding: MainNavigationBinding(),
),
  ];
}