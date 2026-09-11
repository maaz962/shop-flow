import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../app/routes/app_routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),

      body: Obx(
            () {
          final user = authController.userModel.value;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [

              // ACCOUNT HEADER
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [

                    CircleAvatar(
                      radius: 30,
                      backgroundColor:
                      Theme.of(context).colorScheme.primary,
                      child: const Icon(
                        Icons.person,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          Text(
                            user?.name ?? 'User',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            user?.email ?? 'No email',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer
                                  .withOpacity(0.7),
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            user?.role?.toUpperCase() ?? 'USER',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ACCOUNT
              const Text(
                'Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.person_outline,
                  ),
                  title: const Text('Profile'),
                  subtitle: const Text(
                    'View and manage your profile',
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.profileScreen,
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // APPEARANCE
              const Text(
                'Appearance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Card(
                child: Obx(
                      () => SwitchListTile(
                    secondary: Icon(
                      themeController.isDarkMode.value
                          ? Icons.dark_mode
                          : Icons.light_mode,
                    ),

                    title: const Text(
                      'Dark Mode',
                    ),

                    subtitle: Text(
                      themeController.isDarkMode.value
                          ? 'Dark theme is enabled'
                          : 'Light theme is enabled',
                    ),

                    value:
                    themeController.isDarkMode.value,

                    onChanged: (_) {
                      themeController.toggleTheme();
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ABOUT
              const Text(
                'About',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                  ),
                  title: const Text(
                    'About ShopFlow',
                  ),
                  subtitle: const Text(
                    'E-commerce application',
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    Get.defaultDialog(
                      title: 'ShopFlow',
                      middleText:
                      'ShopFlow is an e-commerce platform for customers and sellers.',
                      textConfirm: 'OK',
                      onConfirm: () {
                        Get.back();
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              // LOGOUT
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),

                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  onTap: () {
                    Get.defaultDialog(
                      title: 'Logout',

                      middleText:
                      'Are you sure you want to logout?',

                      textCancel: 'Cancel',

                      textConfirm: 'Logout',

                      confirmTextColor: Colors.white,

                      onConfirm: () async {
                        Get.back();

                        await authController.logout();
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // APP NAME
              Center(
                child: Text(
                  'ShopFlow',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}