import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../controllers/order_controller.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SafeArea(
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
                    ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                // Product placeholder
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.image_outlined,
                      size: 45,
                    ),
                    title: const Text(
                      'Product Name',
                    ),
                    subtitle: const Text(
                      'Quantity: 1',
                    ),
                    trailing: const Text(
                      '\$0.00',
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  'Order Details',
                  style: Theme.of(context)
                  .textTheme
                    .titleLarge
                    ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.location_on_outlined,
                  ),
                  title: Text('Delivery Address'),
                  subtitle: Text(
                    'Address will be added later',
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),

                const Divider(),

                const SizedBox(height: 20),

                // Price Summary
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal'),
                    Text('\$0.00'),
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

                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$0.00',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                        final success = await orderController.createOrder(
                          items: [
                            {
                              'productId': 'test_product',
                              'title': 'product Name',
                              'price': 0.0,
                              'quantity': 1,
                            }
                          ],
                          totalAmount: 0.0,
                        );
                        if (success) {
                          Get.offNamed(
                            AppRoutes.orders,
                          );
                        }
                      },
                    child: orderController
                    .isLoading.value
                    ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      'Place Order',
                    ),
                        ),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}