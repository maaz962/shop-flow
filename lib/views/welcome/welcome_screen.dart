import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';

class WelcomeScreen extends StatelessWidget{
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                  ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 130,
                    height: 130,
                  ),

                  const SizedBox(height: 24,),

                  Text(
                    'Welcome to ShopFlow',
                    style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8,),

                  Text(
                    'Shop smart. Sell easy.',
                    style: Theme.of(context)
                    .textTheme
                    .bodyLarge,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Customer
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.toNamed(AppRoutes.login);
                      },
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                      ),
                      label: const Text(
                        'Shop on ShopFlow',
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Seller
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.login,
                          arguments: 'seller',
                        );
                      },
                      icon: const Icon(
                        Icons.store_outlined,
                      ),
                      label: const Text(
                        'Sell on ShopFlow',
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  TextButton(
                    onPressed: () {
                      Get.offNamed(AppRoutes.home);
                    },
                    child: const Text(
                      'Continue as Guest',
                    ),
                  ),
                ],
              ),
              ),
            )
          )),
    );
  }
}