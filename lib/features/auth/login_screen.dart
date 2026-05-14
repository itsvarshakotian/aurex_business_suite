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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF020617)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Center(
          child: Container(
            width: 420,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),

            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.05),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha:0.08)),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// 🔥 BRAND (CENTERED)
                Column(
                  children: [
                    Text(
                      "AUREX",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: ColorResources.profileCircle(context),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Enterprise Business Suite",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                /// FORM SECTION
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    /// USERNAME
                    TextField(
                      controller: controller.usernameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Username",
                        filled: true,
                        fillColor: Colors.white.withValues(alpha:0.05),

                        prefixIcon: const Icon(Icons.person_outline, color: Colors.white54),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: ColorResources.profileCircle(context),
                            width: 1.4,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// PASSWORD
                    Obx(
                      () => TextField(
                        controller: controller.passwordController,
                        obscureText: !controller.isPasswordVisible.value,
                        style: const TextStyle(color: Colors.white),

                        decoration: InputDecoration(
                          labelText: "Password",
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.05),

                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.white54),

                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white54,
                            ),
                            onPressed: controller.isPasswordVisible.toggle,
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: ColorResources.profileCircle(context),
                              width: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ROLE LABEL
                    Text(
                      "Select Role",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white60,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// ROLE SELECTOR
                    Obx(
                      () => Row(
                        children: ["Admin", "Manager", "Staff"].map((role) {
                          final isSelected =
                              controller.selectedRole.value == role;

                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.selectedRole.value = role;
                              },

                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(vertical: 12),

                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? ColorResources.profileCircle(context)
                                      : Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),

                                child: Center(
                                  child: Text(
                                    role,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// LOGIN BUTTON
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorResources.profileCircle(context),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: controller.login,
                        child: Text(
                          "Login",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}