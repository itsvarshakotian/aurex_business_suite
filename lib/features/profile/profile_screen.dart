import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),

      body: Obx(() {
        return Stack(
          children: [

            /// 🔥 HEADER (BIG RECTANGLE)
            Container(
              height: 260,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1E293B),
                    Color(0xFF0F172A),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            /// 🔥 CONTENT
            SingleChildScrollView(
              child: Column(
                children: [

                  const SizedBox(height: 80),

                  /// 🔥 PROFILE IMAGE + EDIT ICON
                  Stack(
                    children: [

                      GestureDetector(
                        onTap: c.showImageSource,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            radius: 46,
                            backgroundImage:
                                c.profileImagePath.value.isNotEmpty
                                    ? FileImage(
                                        File(c.profileImagePath.value))
                                    : null,
                            child: c.profileImagePath.value.isEmpty
                                ? const Icon(Icons.person,
                                    color: Colors.white, size: 40)
                                : null,
                          ),
                        ),
                      ),

                      /// ✏️ EDIT ICON
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: c.showImageSource,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: const Icon(Icons.edit,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// NAME
                  Text(
                    c.name.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// ROLE BADGE
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: Text(
                      c.role.value.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white, fontSize: 12),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔥 MAIN CARD (FLOATING)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [

                        /// INFO
                        infoRow("Email",
                            c.profileData["Email"] ?? "-"),
                        divider(),
                        infoRow("Phone",
                            c.profileData["Phone"] ?? "-"),

                        const SizedBox(height: 16),

                        /// STATS
                        GridView.builder(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(),
                          itemCount: c.statsData.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.4,
                          ),
                          itemBuilder: (_, i) {
                            final item =
                                c.statsData.entries.toList()[i];

                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(14),
                                color: Colors.white.withOpacity(0.05),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(item.value,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight:
                                              FontWeight.bold)),
                                  const Spacer(),
                                  Text(item.key,
                                      style: const TextStyle(
                                          color: Colors.grey)),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        /// ACTIONS
                        actionTile("Edit Profile",
                            () => Get.to(() => EditProfileScreen())),
                        divider(),
                        actionTile("Change Password",
                            () => Get.to(() => ChangePasswordScreen())),

                        const SizedBox(height: 16),

                        /// SETTINGS
                        switchTile("Notifications",
                            c.notificationsEnabled,
                            c.updateNotifications),
                        switchTile("Dark Mode",
                            c.isDarkMode, c.updateTheme),

                        const SizedBox(height: 16),

                        /// LOGOUT
                        ElevatedButton(
                          onPressed: c.logout,
                          child: const Text("Logout"),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget infoRow(String title, String value) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(color: Colors.grey)),
        Text(value,
            style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget actionTile(String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title:
          Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  Widget switchTile(String title, RxBool value,
      Function(bool) onChanged) {
    return Obx(() => SwitchListTile(
          value: value.value,
          onChanged: onChanged,
          title: Text(title,
              style: const TextStyle(color: Colors.white)),
        ));
  }

  Widget divider() {
    return Divider(color: Colors.white.withOpacity(0.1));
  }
}