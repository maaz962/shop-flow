import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/order_controller.dart';
import '../../models/address_model.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  void _showAddressDialog(
      BuildContext context,
      AuthController authController,
      AddressModel? existing,
      ) {
    final streetController =
    TextEditingController(text: existing?.street ?? '');
    final cityController =
    TextEditingController(text: existing?.city ?? '');
    final phoneController =
    TextEditingController(text: existing?.phone ?? '');

    Get.defaultDialog(
      title: existing == null ? 'Add Delivery Address' : 'Edit Delivery Address',
      content: Column(
        children: [
          TextField(
            controller: streetController,
            decoration: const InputDecoration(labelText: 'Street Address'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: cityController,
            decoration: const InputDecoration(labelText: 'City'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Phone Number'),
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

        await authController.updateDefaultAddress(
          AddressModel(street: street, city: city, phone: phone),
        );

        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();
    final CartController cartController = Get.find<CartController>();
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const Center(
            child: Text('Your cart is empty.'),
          );
        }

        final subtotal = cartController.subtotal;
        const double shipping = 0.0;
        final total = subtotal + shipping;

        final address = authController.userModel.value?.defaultAddress;
        final hasAddress = address != null && address.isComplete;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Summary',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                ...cartController.cartItems.map((product) {
                  final quantity = cartController.getQuantity(product);
                  final itemTotal = product.price * quantity;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: product.thumbnail.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.thumbnail,
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image_not_supported_outlined,
                              size: 40,
                            );
                          },
                        ),
                      )
                          : const Icon(Icons.image_outlined, size: 40),
                      title: Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text('Quantity: $quantity'),
                      trailing: Text(
                        '\$${itemTotal.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 20),

                Text(
                  'Order Details',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                // DELIVERY ADDRESS — now functional
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.location_on_outlined,
                    color: hasAddress ? null : Colors.red,
                  ),
                  title: const Text('Delivery Address'),
                  subtitle: Text(
                    hasAddress
                        ? '${address.street}, ${address.city}\nPhone: ${address.phone}'
                        : 'No address added — please add one',
                    style: hasAddress ? null : const TextStyle(color: Colors.red),
                  ),
                  isThreeLine: hasAddress,
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showAddressDialog(
                    context,
                    authController,
                    address,
                  ),
                ),

                const Divider(),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal'),
                    Text('\$${subtotal.toStringAsFixed(2)}'),
                  ],
                ),

                const SizedBox(height: 10),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shipping'),
                    Text('\$0.00'),
                  ],
                ),

                const Divider(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Place Order
                Obx(
                      () => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: orderController.isLoading.value
                          ? null
                          : () async {
                        final currentAddress =
                            authController.userModel.value?.defaultAddress;

                        if (currentAddress == null ||
                            !currentAddress.isComplete) {
                          Get.snackbar(
                            'Address Required',
                            'Please add a delivery address before placing the order.',
                          );
                          return;
                        }

                        final items = cartController.cartItems.map((product) {
                          return {
                            'productId': product.firestoreId,
                            'ownerId': product.ownerId,
                            'title': product.title,
                            'price': product.price,
                            'quantity': cartController.getQuantity(product),
                          };
                        }).toList();

                        final success = await orderController.createOrder(
                          items: items,
                          totalAmount: total,
                          deliveryAddress: currentAddress.toMap(),
                        );

                        if (success) {
                          cartController.clearCart();
                          Get.offNamed(AppRoutes.orders);
                        }
                      },
                      child: orderController.isLoading.value
                          ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Text('Place Order'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}