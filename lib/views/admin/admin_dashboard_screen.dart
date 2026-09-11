import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_flow_app/app/routes/app_routes.dart';
import 'package:shop_flow_app/controllers/auth_controller.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    final adminName =
        authController.userModel.value?.name ?? 'Admin';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              authController.logout();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Welcome
            Text(
              'Welcome, $adminName 👋',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Manage your ShopFlow platform from here.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 25),

            // Statistics
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              children: const [
                _StatCard(
                  title: 'Users',
                  value: '0',
                  icon: Icons.people,
                ),
                _StatCard(
                  title: 'Sellers',
                  value: '0',
                  icon: Icons.store,
                ),
                _StatCard(
                  title: 'Products',
                  value: '0',
                  icon: Icons.inventory_2,
                ),
                _StatCard(
                  title: 'Orders',
                  value: '0',
                  icon: Icons.shopping_bag,
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _DashboardCard(
              icon: Icons.people_outline,
              title: 'Manage Users',
              subtitle: 'View and manage customer accounts',
              onTap: () {
                // Coming soon
              },
            ),

            _DashboardCard(
              icon: Icons.store_outlined,
              title: 'Manage Sellers',
              subtitle: 'View and manage seller accounts',
              onTap: () {
                // Coming soon
              },
            ),

            _DashboardCard(
              icon: Icons.inventory_2_outlined,
              title: 'Manage Products',
              subtitle: 'View, edit and delete products',
              onTap: () {
                // Coming soon
              },
            ),

            _DashboardCard(
              icon: Icons.shopping_bag_outlined,
              title: 'Manage Orders',
              subtitle: 'View and manage all orders',
              onTap: () {
                // Coming soon
              },
            ),

            _DashboardCard(
              icon: Icons.category_outlined,
              title: 'Categories',
              subtitle: 'Manage product categories',
              onTap: () {
                // Coming soon
              },
            ),

            _DashboardCard(
              icon: Icons.settings_outlined,
              title: 'Admin Settings',
              subtitle: 'Manage admin account and settings',
              onTap: () {
                Get.toNamed(AppRoutes.settings);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== Statistics Card ====================

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              size: 30,
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== Dashboard Card ====================

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}