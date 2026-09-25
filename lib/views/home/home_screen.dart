import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../controllers/category_controller.dart';
import '../../controllers/firestore_product_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../widgets/customer_bottom_nav.dart';
import '../../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController =
    Get.find<ThemeController>();

    final firestoreProductController =
    Get.find<FirestoreProductController>();

    final categoryController =
    Get.find<CategoryController>();

    // Make sure WishlistController exists before ProductCard uses it.
    Get.find<WishlistController>();

    return Scaffold(
      extendBody: true,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 16),

            const Text(
              'ShopFlow',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            // Orders
            IconButton(
              onPressed: () =>
                  Get.toNamed(AppRoutes.orders),
              icon: const Icon(
                Icons.receipt_long_outlined,
              ),
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
              onPressed: () =>
                  Get.toNamed(AppRoutes.settings),
              icon: const Icon(
                Icons.settings,
              ),
            ),
          ],
        ),
      ),

      body: Obx(() {
        // Product loading
        if (firestoreProductController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Product error
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

        // Central categories
        final categories = [
          'All',
          ...categoryController.activeCategories
              .map((category) => category.name),
        ];

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // SEARCH BAR
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  0,
                ),
                child: SizedBox(
                  height: 46,
                  child: TextField(
                    controller:
                    firestoreProductController
                        .searchController,
                    onChanged: (value) {
                      firestoreProductController
                          .searchProducts(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(
                        Icons.search,
                      ),
                      suffixIcon: Obx(
                            () =>
                        firestoreProductController
                            .searchQuery
                            .value
                            .isNotEmpty
                            ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                          ),
                          onPressed: () {
                            firestoreProductController
                                .clearSearch();
                          },
                        )
                            : const SizedBox.shrink(),
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(
                        vertical: 0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                  ),
                ),
              ),

              // CATEGORIES
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  18,
                  16,
                  10,
                ),
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Horizontal category list
              SizedBox(
                height: 40,
                child: categoryController
                    .activeCategories
                    .isEmpty
                    ? const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'No categories available',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
                    : ListView.builder(
                  scrollDirection:
                  Axis.horizontal,
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category =
                    categories[index];

                    return Obx(() {
                      final isSelected =
                          firestoreProductController
                              .selectedCategory
                              .value ==
                              category;

                      return Padding(
                        padding:
                        const EdgeInsets.only(
                          right: 8,
                        ),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (_) {
                            firestoreProductController
                                .filterByCategory(
                              category,
                            );
                          },
                          selectedColor:
                          Theme.of(context)
                              .colorScheme
                              .primary,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context)
                                .colorScheme
                                .onSurface,
                            fontWeight:
                            FontWeight.w500,
                          ),
                          backgroundColor:
                          Theme.of(context)
                              .colorScheme
                              .surface,
                          side: BorderSide(
                            color: isSelected
                                ? Colors.transparent
                                : Colors
                                .grey
                                .shade300,
                          ),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(20),
                          ),
                          showCheckmark: false,
                        ),
                      );
                    });
                  },
                ),
              ),

              // HEADER
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

              // PRODUCTS / EMPTY STATES

              // No products exist in Firestore
              if (firestoreProductController
                  .allProducts
                  .isEmpty)
                const Padding(
                  padding: EdgeInsets.only(
                    top: 60,
                    left: 20,
                    right: 20,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 50,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No products available',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'There are currently no products available.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                )

              // Products exist, but search/category found nothing
              else if (firestoreProductController
                  .products
                  .isEmpty)
                const Padding(
                  padding: EdgeInsets.only(
                    top: 60,
                    left: 20,
                    right: 20,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off_outlined,
                          size: 50,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Try a different search or category.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                )

              // Products
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
                      shrinkWrap: true,
                      physics:
                      const NeverScrollableScrollPhysics(),
                      padding:
                      const EdgeInsets.all(16),
                      itemCount:
                      firestoreProductController
                          .products
                          .length,
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.52,
                      ),
                      itemBuilder: (context, index) {
                        final product =
                        firestoreProductController
                            .products[index];

                        return ProductCard(
                          product: product,
                        );
                      },
                    );
                  },
                ),

              // Extra space for floating navigation bar
              const SizedBox(height: 30),
            ],
          ),
        );
      }),

      // CUSTOMER BOTTOM NAVIGATION
      bottomNavigationBar:
      const CustomerBottomNav(
        currentIndex: 0,
      ),
    );
  }
}