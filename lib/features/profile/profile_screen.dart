import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_controller.dart';
import 'settings_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0B1220),
              Color(0xFF0F172A),
              Color(0xFF020617),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 24),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Row(
                  children: [
                    IconButton(
                      onPressed: Get.back,
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Profile",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// PROFILE CARD
                Obx(() {
                  final path = controller.profileImagePath.value;

                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(0.05),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),

                    child: Row(
                      children: [

                        /// IMAGE
                        GestureDetector(
                          onTap: controller.pickImage,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                Colors.white.withOpacity(0.1),
                            backgroundImage: path.isNotEmpty
                                ? FileImage(File(path))
                                : null,
                            child: path.isEmpty
                                ? const Icon(Icons.camera_alt,
                                    color: Colors.white)
                                : null,
                          ),
                        ),

                        const SizedBox(width: 16),

                        /// NAME + ROLE
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.name.value,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              controller.role.value,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white
                                    .withOpacity(0.6),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 24),

                /// ACTIONS
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.05),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),

                  child: Column(
                    children: [

                      /// EDIT NAME
                      buildTile(
                        icon: Icons.edit,
                        title: "Edit Name",
                        onTap: () {
                          final txt = TextEditingController(
                              text: controller.name.value);

                          Get.dialog(
                            AlertDialog(
                              title: const Text("Edit Name"),
                              content: TextField(controller: txt),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    controller.saveName(txt.text);
                                    Get.back();
                                  },
                                  child: const Text("Save"),
                                )
                              ],
                            ),
                          );
                        },
                      ),

                      divider(),

                      /// SETTINGS
                      buildTile(
                        icon: Icons.settings,
                        title: "Settings",
                        onTap: () {
                          final settings =
                              Get.put(SettingsController());

                          Get.bottomSheet(
                            Obx(() {
                              return Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1A1D24),
                                  borderRadius:
                                      BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                ),

                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [

                                    const Text("Settings",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18)),

                                    const SizedBox(height: 20),

                                    SwitchListTile(
                                      value: settings.isDarkMode.value,
                                      onChanged:
                                          settings.toggleTheme,
                                      title: const Text("Dark Mode",
                                          style: TextStyle(
                                              color: Colors.white)),
                                    ),

                                    SwitchListTile(
                                      value: settings
                                          .notificationsEnabled.value,
                                      onChanged: settings
                                          .toggleNotifications,
                                      title: const Text("Notifications",
                                          style: TextStyle(
                                              color: Colors.white)),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          );
                        },
                      ),

                      divider(),

                      /// LOGOUT
                      buildTile(
                        icon: Icons.logout,
                        title: "Logout",
                        color: Colors.red,
                        onTap: () {
                          Get.dialog(
                            AlertDialog(
                              title: const Text("Logout"),
                              content: const Text(
                                  "Are you sure you want to logout?"),
                              actions: [
                                TextButton(
                                  onPressed: Get.back,
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: controller.logout,
                                  child: const Text("Logout"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTile({
    required IconData icon,
    required String title,
    Color color = Colors.white,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title,
          style: TextStyle(color: color)),
      trailing: const Icon(Icons.arrow_forward_ios,
          size: 14, color: Colors.white),
      onTap: onTap,
    );
  }

  Widget divider() {
    return Divider(
      color: Colors.white.withOpacity(0.08),
      height: 1,
    );
  }
}