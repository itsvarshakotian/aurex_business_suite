import 'package:aurex_business_suite/core/resources/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final TextEditingController oldPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  final RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1220),
        elevation: 0,
        title: const Text("Change Password"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// OLD PASSWORD
            buildField("Old Password", oldPassController),

            const SizedBox(height: 16),

            /// NEW PASSWORD
            buildField("New Password", newPassController),

            const SizedBox(height: 16),

            /// CONFIRM PASSWORD
            buildField("Confirm Password", confirmPassController),

            const Spacer(),

            /// BUTTON
            Obx(() {
              return GestureDetector(
                onTap: isLoading.value ? null : changePassword,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: isLoading.value
                        ? Colors.grey
                        : ColorResources.profileCircle(context),
                  ),
                  child: Center(
                    child: isLoading.value
                        ? const CircularProgressIndicator(
                            color: Colors.white)
                        : const Text(
                            "Update Password",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// 🔥 CHANGE PASSWORD LOGIC
  void changePassword() async {
    final oldPass = oldPassController.text.trim();
    final newPass = newPassController.text.trim();
    final confirmPass = confirmPassController.text.trim();

    /// VALIDATIONS
    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    if (newPass.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters");
      return;
    }

    if (newPass != confirmPass) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    try {
      isLoading.value = true;

      /// 🔥 TEMP SUCCESS (replace with API later)
      await Future.delayed(const Duration(seconds: 1));

      Get.back();

      Get.snackbar("Success", "Password updated successfully");

    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔥 INPUT FIELD UI
  Widget buildField(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(title,
            style: const TextStyle(
                color: Colors.grey, fontSize: 12)),

        const SizedBox(height: 6),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            obscureText: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}