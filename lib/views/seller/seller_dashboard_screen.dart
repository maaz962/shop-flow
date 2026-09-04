import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../controllers/auth_controller.dart';

class SellerDashboardScreen extends StatelessWidget{
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Dashboard'),
        actions: [
          IconButton(
            onPressed: authController.logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${authController.userModel.value?.name ?? 'Seller'}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          const SizedBox(height: 8,),

          const Text('Manage your store and products',),

          const SizedBox(height: 24,),

          Expanded(
              child: GridView.count (
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisExtent: 16,
                children: [
                  _DashboardCard(
                    icon : Icons.inventory_2_outlined,
                    title: 'My Products',
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.myProducts,
                      );
                    },
                  ),

                  _DashboardCard(
                    icon: Icons.add_box_outlined,
                    title: 'Add Product',
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.addProduct,
                      );
                    },
                  ),

                  _DashboardCard(
                    icon: Icons.shopping_cart_outlined,
                    title: 'Orders',
                    onTap: () {
                      Get.snackbar('Coming Soon', 'Orders will be available soon');
                    },
                  ),

                  _DashboardCard(
                    icon: Icons.store_outlined,
                    title: 'Store Profile',
                    onTap: () {
                      Get.snackbar('Coming soon', 'Store profile will be available soon.',);
                    },
                  ),

                  _DashboardCard(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.settings,
                      );
                    },
                  ),
                ],
              ),
          ),
        ],
      ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.onTap,
});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
            ),

            const SizedBox(height: 12,),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),),
      ),
    );
  }
}