import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../controllers/theme_controller.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopFlow'),

        actions: [
          Obx(
              () => IconButton(
                onPressed: themeController.toggleTheme,
                icon: Icon(
                  themeController.isDarkMode.value
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
              ),
          ),

          IconButton(
              onPressed: () {
                Get.toNamed(AppRoutes.settings);
              },
              icon: const Icon(Icons.settings),
          ),
        ],
      ),

      body: const Center(
        child: Text(
          'Home Screen',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}