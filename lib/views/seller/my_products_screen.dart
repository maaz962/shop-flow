import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../controllers/firestore_product_controller.dart';
import '../../models/product_model.dart';

class MyProductsScreen extends StatefulWidget{
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductScreenState();
}

class _MyProductScreenState extends State<MyProductsScreen> {
  final productController = Get.find<FirestoreProductController>();
  
  @override
  void initState() {
    super.initState();
    
    productController.getMyProducts();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        actions: [
          IconButton(onPressed: () {
            Get.toNamed(AppRoutes.addProduct);
          },
          icon: const Icon(Icons.add),
          ),
        ],
      ),

      body: Obx(() {
        if(productController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if(productController.products.isEmpty) {
          return const Center(
            child: Text(
              'You have no products yet.',
            ),
          );
        }

        return RefreshIndicator(
            onRefresh: productController.getMyProducts,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
                itemCount: productController.products.length,
                itemBuilder: (context, index) {
                final product = productController.products[index];

                return _ProductCard(
                  product: product,
                  onEdit: () {
                    Get.toNamed(
                      AppRoutes.editProduct,
                      arguments: product,
                    );
                  },
                  onDelete: () {
                    _showDeleteDialog(product);
                  },
                );
                },
            ),
        );
      }),
    );
  }

  void _showDeleteDialog(ProductModel product) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Product'),
        content: Text(
          'Are you sure you want to delete "${product.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(onPressed: () async {
            Get.back();

            await productController.deleteProduct(product);
          },
              child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget{
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductCard({
    required this.product,
    required this.onEdit,
    required this.onDelete,
});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        leading: product.thumbnail.isNotEmpty
        ? ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product.thumbnail,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace){
              return const Icon(
                Icons.image_not_supported_outlined,
                size: 40,
              );
            },
          ),
        )
            : const Icon(
          Icons.inventory_2_outlined,
          size: 40,
        ),

        title: Text(
          product.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            }

            if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (context) => [
          const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline),
              SizedBox(width: 8),
              Text('Delete'),
            ],
          ),
        ),
          ],
      ),
    ),
    );
  }
}