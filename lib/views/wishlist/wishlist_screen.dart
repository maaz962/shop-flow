import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/wishlist_controller.dart';
import '../../widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Make sure WishlistController exists even if
    // WishlistScreen is opened directly.
    final wishlistController = Get.put(WishlistController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
      ),

      body: Obx(() {
        if (wishlistController.wishlistProducts.isEmpty) {
          return const Center(
            child: Text(
              'Your wishlist is empty ❤️',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            int columns;

            if (constraints.maxWidth >= 1200) {
              columns = 5;
            } else if (constraints.maxWidth >= 900) {
              columns = 4;
            } else if (constraints.maxWidth >= 600) {
              columns = 3;
            } else {
              columns = 2;
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount:
              wishlistController.wishlistProducts.length,
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) {
                final product =
                wishlistController.wishlistProducts[index];

                return ProductCard(
                  product: product,
                );
              },
            );
          },
        );
      }),
    );
  }
}