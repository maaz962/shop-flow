import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/product_controller.dart';
import '../../widgets/product_skeleton.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    final themeController = Get.find<ThemeController>();
    final productController = Get.put(ProductController());
    // final ProductController productController =  Get.find<ProductController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopFlow'),

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

          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.addProduct);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      body: Obx(() {
        if (productController.isLoading.value) {
          return const ProductSkeleton();
        }

        if (productController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              productController.errorMessage.value,
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: productController.products.length,
                itemBuilder: (context, index) {
                  final product =
                  productController.products[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.editProduct,
                          arguments: product,
                        );
                      },

                      leading: product.thumbnail.isNotEmpty
                          ? Image.network(
                        product.thumbnail,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.image_not_supported,
                        ),
                      ),

                      title: Text(product.title),

                      subtitle: Text(
                        '\$${product.price}',
                      ),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '⭐ ${product.rating}',
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              Get.defaultDialog(
                                title: 'Delete Product',
                                middleText:
                                'Are you sure you want to delete this product?',
                                textCancel: 'Cancel',
                                textConfirm: 'Delete',
                                onConfirm: () async {
                                  Get.back();

                                  await productController
                                      .deleteProduct(product.id);

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
                    ),
                  );
                },
              ),
            ),

            // Pagination
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