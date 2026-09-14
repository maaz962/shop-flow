import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shop_flow_app/app/routes/app_routes.dart';
import 'package:shop_flow_app/controllers/admin_controller.dart';
import 'package:shop_flow_app/controllers/auth_controller.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    final adminController = Get.put(
      AdminController(),
    );

    final adminName =
        authController.userModel.value?.name ?? 'Admin';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              authController.logout();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Obx(() {
        if (adminController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (adminController.errorMessage.value.isNotEmpty) {
          return _ErrorView(
            message: adminController.errorMessage.value,
            onRetry: adminController.refreshDashboard,
          );
        }

        return RefreshIndicator(
          onRefresh: adminController.refreshDashboard,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWideScreen =
                  constraints.maxWidth >= 900;

              return SingleChildScrollView(
                physics:
                const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(
                  isWideScreen ? 32 : 20,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 1400,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        _WelcomeSection(
                          adminName: adminName,
                        ),

                        const SizedBox(height: 28),

                        const _SectionTitle(
                          title: 'Platform Overview',
                          subtitle:
                          'Monitor your ShopFlow platform',
                        ),

                        const SizedBox(height: 16),

                        _StatsGrid(
                          controller: adminController,
                          isWideScreen: isWideScreen,
                        ),

                        const SizedBox(height: 32),

                        const _SectionTitle(
                          title: 'Management',
                          subtitle:
                          'Manage different areas of your platform',
                        ),

                        const SizedBox(height: 16),

                        _ManagementGrid(
                          isWideScreen: isWideScreen,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  final String adminName;

  const _WelcomeSection({
    required this.adminName,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        Theme.of(context).colorScheme.primary;

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: primaryColor.withValues(
                  alpha: 0.1,
                ),
              ),
              child: Icon(
                Icons.admin_panel_settings_outlined,
                size: 32,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, $adminName!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Manage and monitor your ShopFlow platform from one place.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
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

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final AdminController controller;
  final bool isWideScreen;

  const _StatsGrid({
    required this.controller,
    required this.isWideScreen,
  });

  @override
  Widget build(BuildContext context) {
    final cards = [
      _StatData(
        title: 'Total Users',
        value: controller.totalUsers.toString(),
        icon: Icons.people_alt_outlined,
      ),
      _StatData(
        title: 'Total Sellers',
        value: controller.totalSellers.toString(),
        icon: Icons.storefront_outlined,
      ),
      _StatData(
        title: 'Total Products',
        value: controller.totalProducts.toString(),
        icon: Icons.inventory_2_outlined,
      ),
      _StatData(
        title: 'Total Orders',
        value: controller.totalOrders.toString(),
        icon: Icons.shopping_bag_outlined,
      ),
      _StatData(
        title: 'Total Revenue',
        value:
        '\$${controller.totalRevenue.toStringAsFixed(2)}',
        icon: Icons.payments_outlined,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics:
      const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate:
      SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent:
        isWideScreen ? 280 : 220,
        mainAxisExtent: 145,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return _StatCard(
          data: cards[index],
        );
      },
    );
  }
}

class _StatData {
  final String title;
  final String value;
  final IconData icon;

  const _StatData({
    required this.title,
    required this.value,
    required this.icon,
  });
}

class _StatCard extends StatelessWidget {
  final _StatData data;

  const _StatCard({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        Theme.of(context).colorScheme.primary;

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(12),
                color: primaryColor.withValues(
                  alpha: 0.1,
                ),
              ),
              child: Icon(
                data.icon,
                color: primaryColor,
                size: 22,
              ),
            ),
            Text(
              data.value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              data.title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManagementGrid extends StatelessWidget {
  final bool isWideScreen;

  const _ManagementGrid({
    required this.isWideScreen,
  });

  @override
  Widget build(BuildContext context) {
    final cards = [
      _ManagementData(
        icon: Icons.people_outline,
        title: 'Manage Users',
        subtitle:
        'View and manage customer accounts',
        onTap: () {
          // Phase 4
        },
      ),
      _ManagementData(
        icon: Icons.store_outlined,
        title: 'Manage Sellers',
        subtitle:
        'View and manage seller accounts',
        onTap: () {
          // Phase 5
        },
      ),
      _ManagementData(
        icon: Icons.inventory_2_outlined,
        title: 'Manage Products',
        subtitle:
        'View, edit and delete products',
        onTap: () {
          // Phase 6
        },
      ),
      _ManagementData(
        icon: Icons.shopping_bag_outlined,
        title: 'Manage Orders',
        subtitle:
        'View and manage all orders',
        onTap: () {
          // Phase 7
        },
      ),
      _ManagementData(
        icon: Icons.category_outlined,
        title: 'Categories',
        subtitle:
        'Manage product categories',
        onTap: () {
          // Phase 8
        },
      ),
      _ManagementData(
        icon: Icons.settings_outlined,
        title: 'Admin Settings',
        subtitle:
        'Manage admin account and settings',
        onTap: () {
          Get.toNamed(AppRoutes.settings);
        },
      ),
    ];

    if (isWideScreen) {
      return GridView.builder(
        shrinkWrap: true,
        physics:
        const NeverScrollableScrollPhysics(),
        itemCount: cards.length,
        gridDelegate:
        const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 430,
          mainAxisExtent: 105,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          return _ManagementCard(
            data: cards[index],
          );
        },
      );
    }

    return Column(
      children: cards.map((card) {
        return Padding(
          padding:
          const EdgeInsets.only(bottom: 12),
          child: _ManagementCard(
            data: card,
          ),
        );
      }).toList(),
    );
  }
}

class _ManagementData {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ManagementData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

class _ManagementCard extends StatelessWidget {
  final _ManagementData data;

  const _ManagementCard({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        Theme.of(context).colorScheme.primary;

    return Card(
      elevation: 1,
      child: InkWell(
        borderRadius:
        BorderRadius.circular(12),
        onTap: data.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(12),
                  color: primaryColor.withValues(
                    alpha: 0.1,
                  ),
                ),
                child: Icon(
                  data.icon,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Text(
                      data.title,
                      style: const TextStyle(
                        fontWeight:
                        FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.subtitle,
                      style: TextStyle(
                        color:
                        Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            const Text(
              'Unable to load dashboard',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}