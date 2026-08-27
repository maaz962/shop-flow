import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/product_controller.dart';
import '../../widgets/product_skeleton.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final productController = Get.put(ProductController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ShopFlow',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

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
        // Loading
        if (productController.isLoading.value) {
          return const ProductSkeleton();
        }

        // Error
        if (productController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              productController.errorMessage.value,
              textAlign: TextAlign.center,
            ),
          );
        }

        return Column(
          children: [

            Expanded(
              child: LayoutBuilder(
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

                      final originalPrice =
                          product.price /
                              (1 -
                                  product.discountPercentage /
                                      100);

                      return Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 3,

                        child: InkWell(
                          // EDIT PRODUCT
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.editProduct,
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

                                    // Discount Badge
                                    if (product.discountPercentage > 0)
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: Container(
                                          padding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                            BorderRadius.circular(5),
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
                                  ],
                                ),
                              ),


                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      // Title
                                      Text(
                                        product.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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
                                      Text(
                                        '\$${originalPrice.toStringAsFixed(2)}',
                                        style:
                                        const TextStyle(
                                          fontSize: 12,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),

                                      const SizedBox(height: 5),

                                      // Rating
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 16,
                                            color: Colors.amber,
                                          ),

                                          const SizedBox(width: 3),

                                          Text(
                                            product.rating.toStringAsFixed(1),
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
                                              Icons.delete_outline,
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
                                                onConfirm: () async {
                                                  Get.back();

                                                  await productController.deleteProduct(product.id,);

                                                  Get.snackbar(
                                                    'Deleted',
                                                    '${product.title} deleted successfully',
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),

                                      const Spacer(),

                                      // Free Shipping
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.local_shipping,
                                            size: 16,
                                          ),
                                          const SizedBox(
                                              width: 4),
                                          Text(
                                            'Free Shipping',
                                            style:
                                            TextStyle(
                                              fontSize: 11,
                                              fontWeight:
                                              FontWeight.w600,
                                              color:
                                              Colors.green,
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
            ),


            Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
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

            const SizedBox(height: 10),
          ],
        );
      }),
    );
  }
}