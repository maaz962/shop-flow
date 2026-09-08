import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../controllers/cart_controller.dart';
import 'package:shop_flow_app/app/utils/app_snackbar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(
              () => Text(
            'My Cart (${cartController.itemCount})',
          ),
        ),
      ),
      body: Obx(() {
        // Empty cart
        if (cartController.cartItems.isEmpty) {
          return const _EmptyCart();
        }

        return Column(
          children: [
            // Cart products
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final product =
                  cartController.cartItems[index];

                  final quantity =
                  cartController.getQuantity(product);

                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          // Product image
                          ClipRRect(
                            borderRadius:
                            BorderRadius.circular(8),
                            child: product.thumbnail.isNotEmpty
                                ? Image.network(
                              product.thumbnail,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (
                                  context,
                                  error,
                                  stackTrace,
                                  ) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  alignment:
                                  Alignment.center,
                                  child: const Icon(
                                    Icons
                                        .image_not_supported_outlined,
                                    size: 35,
                                  ),
                                );
                              },
                            )
                                : Container(
                              width: 80,
                              height: 80,
                              alignment:
                              Alignment.center,
                              child: const Icon(
                                Icons
                                    .image_not_supported_outlined,
                                size: 35,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Product information
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  maxLines: 2,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight:
                                    FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Quantity controls
                                Row(
                                  children: [
                                    Container(
                                      decoration:
                                      BoxDecoration(
                                        border: Border.all(
                                          color: Theme.of(
                                            context,
                                          ).dividerColor,
                                        ),
                                        borderRadius:
                                        BorderRadius
                                            .circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              cartController
                                                  .decreaseQuantity(
                                                product,
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.remove,
                                              size: 18,
                                            ),
                                            constraints:
                                            const BoxConstraints(
                                              minWidth: 36,
                                              minHeight: 36,
                                            ),
                                            padding:
                                            EdgeInsets.zero,
                                          ),

                                          SizedBox(
                                            width: 30,
                                            child: Text(
                                              '$quantity',
                                              textAlign:
                                              TextAlign
                                                  .center,
                                              style:
                                              const TextStyle(
                                                fontWeight:
                                                FontWeight
                                                    .bold,
                                              ),
                                            ),
                                          ),

                                          IconButton(
                                            onPressed: () {
                                              cartController
                                                  .increaseQuantity(
                                                product,
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.add,
                                              size: 18,
                                            ),
                                            constraints:
                                            const BoxConstraints(
                                              minWidth: 36,
                                              minHeight: 36,
                                            ),
                                            padding:
                                            EdgeInsets.zero,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Remove button
                          IconButton(
                            onPressed: () {
                              cartController
                                  .removeFromCart(product);

                              AppSnackbar.show(
                                'Cart',
                                'Product removed from cart',
                              );
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Checkout section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color:
                    Theme.of(context).dividerColor,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '\$${cartController.subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.checkout,
                        );
                      },
                      child: const Text(
                        'Proceed to Checkout',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              size: 80,
            ),

            const SizedBox(height: 16),

            Text(
              'Your cart is empty',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Add products to your cart',
            ),
          ],
        ),
      ),
    );
  }
}