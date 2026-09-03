import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../controllers/firestore_product_controller.dart';
import '../../widgets/product_skeleton.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final productController = Get.put(ProductController());
    final wishlistController = Get.put(WishlistController());
    final firestoreProductController =
    Get.find<FirestoreProductController>();

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
                  onChanged: (value) {
                    productController.searchProducts(value);
                  },
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

          // Add Product
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.addProduct);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      body: Obx(() {
        // DummyJSON Loading
        if (productController.isLoading.value) {
          return const ProductSkeleton();
        }

        // DummyJSON Error

        if (productController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              productController.errorMessage.value,
              textAlign: TextAlign.center,
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
                child: Text(
                  'API Products',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),


              if (productController.products.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(
                    child: Text(
                      'No Products found',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              else
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
                      key: ValueKey(
                        productController.products.length,
                      ),

                      // IMPORTANT
                      shrinkWrap: true,
                      physics:
                      const NeverScrollableScrollPhysics(),

                      padding: const EdgeInsets.all(16),

                      itemCount:
                      productController.products.length,

                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.68,
                      ),

                      itemBuilder: (context, index) {
                        final product =
                        productController.products[index];

                        // Calculate original price
                        double originalPrice = product.price;

                        if (product.discountPercentage > 0 &&
                            product.discountPercentage < 100) {
                          originalPrice =
                              product.price /
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
                                                    .image_not_supported,
                                                size: 40,
                                              ),
                                            );
                                          },
                                        )
                                            : const Center(
                                          child: Icon(
                                            Icons
                                                .image_not_supported,
                                            size: 40,
                                          ),
                                        ),
                                      ),

                                      // Discount
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

                                      // Wishlist
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


                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        // Title
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

                                        // Price
                                        Text(
                                          '\$${product.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),

                                        // Original Price
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
                                            ),
                                          ),

                                        const SizedBox(height: 5),

                                        // Rating + Delete
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

                                            // Delete
                                            IconButton(
                                              padding:
                                              EdgeInsets.zero,
                                              constraints:
                                              const BoxConstraints(),
                                              icon: const Icon(
                                                Icons
                                                    .delete_outline,
                                                size: 21,
                                              ),
                                              onPressed: () {
                                                Get.defaultDialog(
                                                  title:
                                                  'Delete Product',
                                                  middleText:
                                                  'Are you sure you want to delete this product?',
                                                  textCancel:
                                                  'Cancel',
                                                  textConfirm:
                                                  'Delete',
                                                  onConfirm:
                                                      () async {
                                                    Get.back();

                                                    await productController
                                                        .deleteProduct(
                                                      product.id,
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),

                                        const Spacer(),

                                        // Free Shipping + Cart
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .local_shipping,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  const Flexible(
                                                    child: Text(
                                                      'Free Shipping',
                                                      style:
                                                      TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                        FontWeight
                                                            .w600,
                                                        color: Colors
                                                            .green,
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
                                                  Get.snackbar(
                                                    'Cart',
                                                    '${product.title} added to cart',
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

              // FIRESTORE TITLE

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Firestore Products',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Obx(() {
                // Loading
                if (firestoreProductController
                    .isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                // Error
                if (firestoreProductController
                    .errorMessage.value.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      firestoreProductController
                          .errorMessage.value,
                    ),
                  );
                }

                // Empty
                if (firestoreProductController.products.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child: Text(
                        'No Firestore products found',
                      ),
                    ),
                  );
                }

                // Responsive Firestore Grid
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
                      // IMPORTANT
                      shrinkWrap: true,
                      physics:
                      const NeverScrollableScrollPhysics(),

                      padding: const EdgeInsets.all(16),

                      itemCount: firestoreProductController
                          .products.length,

                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.68,
                      ),

                      itemBuilder: (context, index) {
                        final product =
                        firestoreProductController
                            .products[index];

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

                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [

                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(
                                          10,
                                        ),
                                      ),
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
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    product.title,
                                    maxLines: 2,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),

                                  const SizedBox(height: 6),


                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  const Text(
                                    'From Firestore',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  const Spacer(),


                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      // Edit
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints:
                                        const BoxConstraints(),
                                        onPressed: () {
                                          Get.toNamed(
                                            AppRoutes.editProduct,
                                            arguments: product,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          size: 20,
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      // Delete
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints:
                                        const BoxConstraints(),
                                        onPressed: () {
                                          Get.defaultDialog(
                                            title:
                                            'Delete Product',
                                            middleText:
                                            'Are you sure you want to delete "${product.title}"?',
                                            textCancel: 'Cancel',
                                            textConfirm: 'Delete',
                                            onConfirm: () async {
                                              Get.back();

                                              await firestoreProductController
                                                  .deleteProduct(
                                                product,
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }),

              const SizedBox(height: 20),

              // PAGINATION

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed:
                    productController.currentPage > 1
                        ? () {
                      productController.goToPage(
                        productController.currentPage - 1,
                      );
                    }
                        : null,
                    icon: const Icon(
                      Icons.chevron_left,
                    ),
                  ),

                  Text(
                    'Page ${productController.currentPage}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      productController.goToPage(
                        productController.currentPage + 1,
                      );
                    },
                    icon: const Icon(
                      Icons.chevron_right,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
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
              icon: const Icon(
                Icons.favorite_border,
              ),
            ),

            // Cart
            IconButton(
              onPressed: () {},
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