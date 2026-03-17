import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/resources/color_resources.dart';
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    return Scaffold(
      backgroundColor: ColorResources.primaryBackground,
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
          decoration: BoxDecoration(
            color: ColorResources.secondaryBackground,
            borderRadius: BorderRadius.circular(24),
            border: const Border(
              top: BorderSide(color: ColorResources.borderLight),
              left: BorderSide(color: ColorResources.borderLight),
              right: BorderSide(color: ColorResources.borderLight),
              bottom: BorderSide(color: ColorResources.borderLight),
            ),
          ),
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Brand Title
                Text(
                  "AUREX",
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: ColorResources.goldPrimary,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Enterprise Business Suite",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: ColorResources.textSecondary,
                  ),
                ),

                const SizedBox(height: 40),

                //USERNAME
                Text(
                  "USERNAME",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: ColorResources.textTertiary,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: controller.usernameController,
                  style: const TextStyle(
                    color: ColorResources.textPrimary,
                  ),
                ),

                const SizedBox(height: 24),

                /// Password Label
                Text(
                  "PASSWORD",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: ColorResources.textTertiary,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: controller.passwordController,
                  obscureText: true,
                  style: const TextStyle(
                    color: ColorResources.textPrimary,
                  ),
                ),

                const SizedBox(height: 24),

                /// Role Dropdown
                DropdownButtonFormField<String>(
                  value: controller.selectedRole.value,
                  dropdownColor: ColorResources.surface,

                  decoration: const InputDecoration(),

                  style: const TextStyle(
                    color: ColorResources.textPrimary,
                  ),

                  items: ["Admin", "Manager", "Staff"]
                      .map(
                        (role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    controller.selectedRole.value = value ?? "Admin";
                  },
                ),

                const SizedBox(height: 36),

                /// Login Button
                controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ColorResources.goldPrimary,
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: controller.login,
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}