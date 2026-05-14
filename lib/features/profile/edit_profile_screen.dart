import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final ProfileController c = Get.find<ProfileController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    /// 🔥 Prefill data
    nameController.text = c.name.value;
    emailController.text = c.profileData["Email"] ?? "";
    phoneController.text = c.profileData["Phone"] ?? "";

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1220),
        elevation: 0,
        title: const Text("Edit Profile"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// 🔥 FORM CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [

                  /// NAME
                  buildField("Name", nameController),

                  const SizedBox(height: 16),

                  /// EMAIL
                  buildField("Email", emailController),

                  const SizedBox(height: 16),

                  /// PHONE (READ ONLY)
                  buildField(
                    "Phone",
                    phoneController,
                    isEditable: false,
                  ),
                ],
              ),
            ),

            const Spacer(),

            /// 🔥 SAVE BUTTON
            GestureDetector(
              onTap: saveProfile,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.8),
                      Colors.blue.withOpacity(0.5),
                    ],
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Save Changes",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 🔥 SAVE LOGIC
  Future<void> saveProfile() async {
    final role = c.role.value;

    /// Update name
    await c.saveName(nameController.text);

    /// Update UI instantly
    c.profileData["Email"] = emailController.text;

    final prefs = await SharedPreferences.getInstance();

    /// 🔥 Save ONLY editable fields
    await prefs.setString("${role}_email", emailController.text);

    Get.back();

    Get.snackbar("Success", "Profile updated");
  }

  /// 🔥 FIELD WIDGET
  Widget buildField(
    String title,
    TextEditingController controller, {
    bool isEditable = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 6),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isEditable
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            readOnly: !isEditable,
            style: TextStyle(
              color: isEditable ? Colors.white : Colors.grey,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}