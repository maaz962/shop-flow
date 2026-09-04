import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../controllers/firestore_product_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/wishlist_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    final firestoreProductController =
    Get.find<FirestoreProductController>();

    final wishlistController = Get.put(WishlistController());

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'ShopFlow',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: SizedBox(
                height: 42,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
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
        if (firestoreProductController
            .errorMessage
            .value
            .isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                firestoreProductController
                    .errorMessage
                    .value,
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
                padding: EdgeInsets.fromLTRB(
                  16,
                  20,
                  16,
                  4,
                ),
                child: Text(
                  'Discover Products',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  10,
                ),
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
                      childAspectRatio: 0.68,
                    ),
                    itemBuilder: (context, index) {
                      final product =
                      firestoreProductController.products[index];

                      double originalPrice = product.price;

                      if (product.discountPercentage > 0 &&
                          product.discountPercentage < 100) {
                        originalPrice = product.price /
                            (1 -
                                product.discountPercentage /
                                    100);
                      }

                      return Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 3,
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.productDetails,
                              arguments: product,
                            );
                          },
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              // IMAGE
                              Expanded(
                                flex: 5,
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: product
                                          .thumbnail
                                          .isNotEmpty
                                          ? Image.network(
                                        product.thumbnail,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (
                                            context,
                                            error,
                                            stackTrace,
                                            ) {
                                          return const Center(
                                            child: Icon(
                                              Icons
                                                  .image_not_supported_outlined,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      )
                                          : const Center(
                                        child: Icon(
                                          Icons
                                              .image_not_supported_outlined,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),

                                    // DISCOUNT
                                    if (product
                                        .discountPercentage >
                                        0)
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: Container(
                                          padding:
                                          const EdgeInsets
                                              .symmetric(
                                            horizontal: 7,
                                            vertical: 4,
                                          ),
                                          decoration:
                                          BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                            BorderRadius
                                                .circular(5),
                                          ),
                                          child: Text(
                                            '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                                            style:
                                            const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight:
                                              FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),

                                    // WISHLIST
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: Obx(
                                            () => IconButton(
                                          onPressed: () {
                                            wishlistController
                                                .toggleWishlist(
                                              product,
                                            );
                                          },
                                          icon: Icon(
                                            wishlistController
                                                .isFavorite(
                                              product.id,
                                            )
                                                ? Icons.favorite
                                                : Icons
                                                .favorite_border,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // PRODUCT INFO
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      // TITLE
                                      Text(
                                        product.title,
                                        maxLines: 2,
                                        overflow:
                                        TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight:
                                          FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      // PRICE
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),

                                      // ORIGINAL PRICE
                                      if (product
                                          .discountPercentage >
                                          0)
                                        Text(
                                          '\$${originalPrice.toStringAsFixed(2)}',
                                          style:
                                          const TextStyle(
                                            fontSize: 12,
                                            decoration:
                                            TextDecoration
                                                .lineThrough,
                                            color: Colors.grey,
                                          ),
                                        ),

                                      const SizedBox(height: 5),

                                      // RATING
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 16,
                                            color: Colors.amber,
                                          ),
                                          const SizedBox(width: 3),
                                          Text(
                                            product.rating
                                                .toStringAsFixed(1),
                                            style:
                                            const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),

                                          const Spacer(),

                                          // Stock
                                          Text(
                                            product.stock > 0
                                                ? 'In stock'
                                                : 'Out of stock',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight:
                                              FontWeight.w600,
                                              color: product.stock >
                                                  0
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const Spacer(),

                                      // SHIPPING + ADD BUTTON
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .local_shipping_outlined,
                                                  size: 16,
                                                ),
                                                SizedBox(width: 4),
                                                Flexible(
                                                  child: Text(
                                                    'Free Shipping',
                                                    style:
                                                    TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                      FontWeight
                                                          .w600,
                                                      color:
                                                      Colors.green,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          const SizedBox(width: 4),

                                          SizedBox(
                                            height: 32,
                                            child:
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                // Cart logic will be
                                                // added later.
                                                Get.snackbar(
                                                  'Cart',
                                                  'Login required to add products to cart',
                                                );
                                              },
                                              icon: const Icon(
                                                Icons
                                                    .shopping_cart_outlined,
                                                size: 15,
                                              ),
                                              label: const Text(
                                                'Add',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                ),
                                              ),
                                              style: ElevatedButton
                                                  .styleFrom(
                                                padding:
                                                const EdgeInsets
                                                    .symmetric(
                                                  horizontal: 8,
                                                ),
                                                minimumSize:
                                                Size.zero,
                                                tapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
          mainAxisAlignment:
          MainAxisAlignment.spaceAround,
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
              icon: const Icon(
                Icons.favorite_border,
              ),
            ),

            // Cart
            IconButton(
              onPressed: () {
                Get.toNamed(AppRoutes.cart);
              },
              icon: const Icon(
                Icons.shopping_cart_outlined,
              ),
            ),

            // Profile
            IconButton(
              onPressed: () {
                Get.toNamed(
                  AppRoutes.profileScreen,
                );
              },
              icon: const Icon(
                Icons.person_outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}