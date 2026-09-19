import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/firestore_product_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    final firestoreProductController =
    Get.find<FirestoreProductController>();

    final cartController = Get.find<CartController>();

    // Make sure WishlistController exists before ProductCard uses it.
    final wishlistController = Get.put(WishlistController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Text(
              'ShopFlow',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: SizedBox(
                height: 42,
                child: TextField(
                  controller: firestoreProductController.searchController,
                  onChanged: (value) {
                    firestoreProductController.searchProducts(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Obx(() =>
                    firestoreProductController.searchQuery.value.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.clear),
                        onPressed: () {
                          firestoreProductController.searchController.clear();
                          firestoreProductController.searchProducts('');
                        },
                    )
                        : const SizedBox.shrink(),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Orders
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.orders);
            },
            icon: const Icon(Icons.receipt_long_outlined),
          ),

          // Theme
          Obx(
                () => IconButton(
              onPressed: themeController.toggleTheme,
              icon: Icon(
                themeController.isDarkMode.value
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
            ),
          ),

          // Settings
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.settings);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),

      body: Obx(() {
        // Loading
        if (firestoreProductController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Error
        if (firestoreProductController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                firestoreProductController.errorMessage.value,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // Empty
        if (firestoreProductController.products.isEmpty) {
          return const Center(
            child: Text(
              'No products available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 4),
                child: Text(
                  'Discover Products',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Text(
                  'Explore products from our sellers',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),

              // Products
              LayoutBuilder(
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
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount:
                    firestoreProductController.products.length,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.58,
                    ),
                    itemBuilder: (context, index) {
                      final product =
                      firestoreProductController.products[index];

                      return ProductCard(
                        product: product,
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        );
      }),

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.home),
            ),

            // Wishlist
            IconButton(
              onPressed: () {
                Get.toNamed(AppRoutes.wishlist);
              },
              icon: const Icon(Icons.favorite_border),
            ),

            // Cart
            Obx(
                  () => Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.cart);
                    },
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                    ),
                  ),
                  if (cartController.itemCount > 0)
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${cartController.itemCount}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Profile
            IconButton(
              onPressed: () {
                Get.toNamed(AppRoutes.profileScreen);
              },
              icon: const Icon(Icons.person_outline),
            ),
          ],
        ),
      ),
    );
  }
}