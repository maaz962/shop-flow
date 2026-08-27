import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../app/routes/app_routes.dart';

class SettingsScreen extends StatelessWidget{
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context){
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),

      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.arrow_back),
            title: const Text('Back to Home'),

            onTap: () {
              Get.back();
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('LogOut'),

            onTap: () {
              Get.defaultDialog(
                title: 'Logout',
                middleText: 'Are you sure you want to logout?',

                textCancel: 'Cancel',
                textConfirm: 'Logout',

                onConfirm: () async {
                  Get.back();

                  await authController.logout();

                  Get.offAllNamed(
                    AppRoutes.login,
                  );
                },
              );
            },
          ),
        ],
      ),

    );
  }
}