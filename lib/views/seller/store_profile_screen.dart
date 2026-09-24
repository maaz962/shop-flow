import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/store_profile_controller.dart';

class StoreProfileScreen extends StatelessWidget {
  StoreProfileScreen({super.key});

  final StoreProfileController controller =
  Get.find<StoreProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Profile'),
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.storeProfile.value == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.storeProfile.value == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.getStoreProfile,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.getStoreProfile,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              _buildStoreHeader(),

              const SizedBox(height: 20),

              _buildStats(),

              const SizedBox(height: 24),

              const Text(
                'Store Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: controller.storeNameController,
                decoration: const InputDecoration(
                  labelText: 'Store Name',
                  hintText: 'Enter your store name',
                  prefixIcon: Icon(
                    Icons.store_outlined,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller:
                controller.descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Store Description',
                  hintText: 'Tell customers about your store',
                  prefixIcon: Icon(
                    Icons.description_outlined,
                  ),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  hintText: 'Enter your phone number',
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              _buildSellerInformation(),

              const SizedBox(height: 24),

              Obx(() {
                return SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: controller.isSaving.value
                        ? null
                        : controller.updateStoreProfile,
                    icon: controller.isSaving.value
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : const Icon(
                        Icons.save_outlined,
                      color: Colors.white,
                    ),
                    label: Text(
                      controller.isSaving.value
                          ? 'Saving...'
                          : 'Save Changes',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStoreHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
              child: Icon(
                Icons.storefront_outlined,
                size: 45,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 14),
            Obx(() {
              final profile =
                  controller.storeProfile.value;

              return Text(
                profile?.storeName.isNotEmpty == true
                    ? profile!.storeName
                    : 'My Store',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
            const SizedBox(height: 6),
            Obx(() {
              final profile =
                  controller.storeProfile.value;

              return Text(
                profile?.storeDescription.isNotEmpty == true
                    ? profile!.storeDescription
                    : 'Add a description for your store',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Obx(() {
      final profile = controller.storeProfile.value;

      return Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.inventory_2_outlined,
              value: '${profile?.productCount ?? 0}',
              title: 'Products',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.shopping_bag_outlined,
              value: '${profile?.orderCount ?? 0}',
              title: 'Orders',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.star_outline,
              value: profile?.rating == 0
                  ? '—'
                  : profile!.rating.toStringAsFixed(1),
              title: 'Rating',
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSellerInformation() {
    return Obx(() {
      final profile = controller.storeProfile.value;

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                'Seller Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _InfoRow(
                icon: Icons.person_outline,
                title: 'Name',
                value: profile?.name.isNotEmpty == true
                    ? profile!.name
                    : 'Not available',
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.email_outlined,
                title: 'Email',
                value: profile?.email.isNotEmpty == true
                    ? profile!.email
                    : 'Not available',
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.badge_outlined,
                title: 'Role',
                value: profile?.role.isNotEmpty == true
                    ? profile!.role
                    : 'Seller',
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String title;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        child: Column(
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}