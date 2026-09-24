import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../models/address_model.dart';
import '../../widgets/customer_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final AuthController authController = Get.find<AuthController>();

  void _showAddressDialog(
      BuildContext context,
      AddressModel? existing,
      ) {
    final streetController =
    TextEditingController(text: existing?.street ?? '');
    final cityController =
    TextEditingController(text: existing?.city ?? '');
    final phoneController =
    TextEditingController(text: existing?.phone ?? '');

    Get.defaultDialog(
      title: existing == null ? 'Add Address' : 'Edit Address',
      content: Column(
        children: [
          TextField(
            controller: streetController,
            decoration: const InputDecoration(
              labelText: 'Street Address',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: cityController,
            decoration: const InputDecoration(
              labelText: 'City',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
            ),
          ),
        ],
      ),
      textCancel: 'Cancel',
      textConfirm: 'Save',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final street = streetController.text.trim();
        final city = cityController.text.trim();
        final phone = phoneController.text.trim();

        if (street.isEmpty || city.isEmpty || phone.isEmpty) {
          Get.snackbar('Error', 'Please fill all address fields');
          return;
        }

        final address = AddressModel(
          street: street,
          city: city,
          phone: phone,
        );

        final success =
        await authController.updateDefaultAddress(address);

        Get.back();

        if (success) {
          Get.snackbar('Success', 'Address saved');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Obx(() {
        final userModel = authController.userModel.value;

        if (userModel == null) {
          return const Center(
            child: Text('No user logged in'),
          );
        }

        final address = userModel.defaultAddress;

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),

              const SizedBox(height: 20),

              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Name'),
                subtitle: Text(userModel.name),
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Email'),
                subtitle: Text(userModel.email),
              ),

              const Divider(),

              // ADDRESS SECTION
              ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: const Text('Delivery Address'),
                subtitle: Text(
                  address != null && address.isComplete
                      ? '${address.street}, ${address.city}\n${address.phone}'
                      : 'No address added yet',
                ),
                isThreeLine: address != null && address.isComplete,
                trailing: TextButton(
                  onPressed: () =>
                      _showAddressDialog(context, address),
                  child: Text(
                    address == null ? 'Add' : 'Edit',
                  ),
                ),
              ),

              const Divider(),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: () async {
                  await authController.logout();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ],
          ),
        );
      }),

      bottomNavigationBar: const CustomerBottomNav(
        currentIndex: 3,
      ),
    );
  }
}