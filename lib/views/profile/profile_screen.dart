import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),

      body: Obx(() {
        final user = authController.user.value;

        if(user == null){
          return const Center(
            child: Text('No user logged in'),
          );
        }
        return Padding(padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),

            const SizedBox(height: 30,),

            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(
                user.email ?? 'Not available',
              ),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Phone'),
              subtitle: Text(
                user.phoneNumber ?? 'Not available',
              ),
            ),

            const SizedBox(height: 30,),

            ElevatedButton.icon(
                onPressed: () async{
                  await authController.logout();
                  Get.back();
                },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            ),
          ],
        ),
        );
      }),


    );
  }
}
