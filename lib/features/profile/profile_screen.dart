import 'dart:io';
import 'dart:ui';
import 'package:aurex_business_suite/core/resources/color_resources.dart';
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
            /// GRADIENT BACKGROUND
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF020617)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            /// CONTENT
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 90),

                  /// PROFILE IMAGE
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      /// GLOW RING
                      Container(
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              ColorResources.profileCircle(
                                context,
                              ).withOpacity(0.4),
                            ],
                          ),
                        ),
                      ),

                      /// IMAGE
                      GestureDetector(
                        onTap: c.showImageSource,
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.black,
                          backgroundImage: c.profileImagePath.value.isNotEmpty
                              ? FileImage(File(c.profileImagePath.value))
                              : null,
                          child: c.profileImagePath.value.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),

                      /// EDIT ICON
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: c.showImageSource,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorResources.profileCircle(context),
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// NAME
                  Text(
                    c.name.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// ROLE
                  Text(
                    c.role.value.toUpperCase(),
                    style: TextStyle(
                      color: ColorResources.profileCircle(context),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// GLASS CARD
                  glassCard(
                    child: Column(
                      children: [
                        sectionTitle(context,"Info"),
                       infoRow(context, "Email", c.profileData["Email"] ?? "-"),
                        divider(),
                       infoRow(context, "Phone", c.profileData["Phone"] ?? "-"),

                        const SizedBox(height: 16),

                        sectionTitle(context,"Overview"),

                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: c.statsData.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.4,
                              ),
                          itemBuilder: (_, i) {
                            final item = c.statsData.entries.toList()[i];

                            return glassCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.value,
                                    style: TextStyle(
                                      color: ColorResources.profileCircle(
                                        context,
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    item.key,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        sectionTitle(context,"Actions"),

                        actionTile(
                          "Edit Profile",
                          () => Get.to(() => EditProfileScreen()),
                        ),
                        divider(),
                        actionTile(
                          "Change Password",
                          () => Get.to(() => ChangePasswordScreen()),
                        ),

                        const SizedBox(height: 16),

                        sectionTitle(context,"Settings"),

                        switchTile(
                          "Notifications",
                          c.notificationsEnabled,
                          c.updateNotifications,
                        ),
                        switchTile("Dark Mode", c.isDarkMode, c.updateTheme),

                        const SizedBox(height: 16),

                        /// LOGOUT
                        GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: ColorResources.secondaryBackground,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(24),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ///  DRAG HANDLE
                                    Container(
                                      height: 4,
                                      width: 40,
                                      margin: const EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        color: ColorResources.borderLight,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),

                                    ///  ICON
                                    Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorResources.error.withOpacity(
                                          0.1,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.logout,
                                        color: ColorResources.profileCircle(context),
                                        size: 28,
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    /// TITLE
                                    const Text(
                                      "Logout?",
                                      style: TextStyle(
                                        color: ColorResources.textPrimary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    /// SUBTEXT
                                    const Text(
                                      "Are you sure you want to logout from your account?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: ColorResources.textSecondary,
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    /// BUTTONS ROW
                                    Row(
                                      children: [
                                        /// CANCEL
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => Get.back(),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 14,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                color: ColorResources.surface,
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    color: ColorResources
                                                        .textPrimary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 12),

                                        /// LOGOUT
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.back();
                                              c.logout();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 14,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                color: ColorResources.profileCircle(context),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  "Logout",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: LinearGradient(
                                colors: [
                                  ColorResources.profileCircle(context).withOpacity(0.4),
                                  ColorResources.profileCircle(context).withOpacity(0.5),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "Logout",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
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

  /// ---------- UI COMPONENTS ----------

  Widget glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget sectionTitle(BuildContext context,String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: TextStyle(
            color: ColorResources.profileCircle(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

Widget infoRow(BuildContext context, String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        Text(
          value,
           style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget actionTile(String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget switchTile(String title, RxBool value, Function(bool) onChanged) {
    return Obx(
      () => SwitchListTile(
        value: value.value,
        onChanged: onChanged,
        title: Text(title, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget divider() {
    return Divider(color: Colors.white.withOpacity(0.1));
  }
}
