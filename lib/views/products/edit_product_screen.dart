import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/product_model.dart';
import '../../models/category_model.dart';
import '../../controllers/category_controller.dart';
import '../../controllers/firestore_product_controller.dart';
import 'package:shop_flow_app/app/utils/app_snackbar.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel product;

  const EditProductScreen({
    super.key,
    required this.product,
  });

  @override
  State<EditProductScreen> createState() =>
      _EditProductScreenState();
}

class _EditProductScreenState
    extends State<EditProductScreen> {
  late final TextEditingController titleController;
  late final TextEditingController priceController;

  final firestoreProductController =
  Get.find<FirestoreProductController>();

  final categoryController =
  Get.find<CategoryController>();

  CategoryModel? selectedCategory;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.product.title,
    );

    priceController = TextEditingController(
      text: widget.product.price.toString(),
    );

    // Load active categories
    categoryController.getActiveCategories().then((_) {
      if (!mounted) return;

      // Find the product's current category
      for (final category
      in categoryController.activeCategories) {
        if (category.id == widget.product.categoryId) {
          setState(() {
            selectedCategory = category;
          });
          break;
        }
      }

      // Compatibility for old products
      // that may not have categoryId.
      if (selectedCategory == null &&
          widget.product.categoryName.isNotEmpty) {
        for (final category
        in categoryController.activeCategories) {
          if (category.name.toLowerCase() ==
              widget.product.categoryName
                  .toLowerCase()) {
            setState(() {
              selectedCategory = category;
            });
            break;
          }
        }
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();

    super.dispose();
  }

  Future<void> updateProduct() async {
    final title = titleController.text.trim();

    final price = double.tryParse(
      priceController.text.trim(),
    );

    if (title.isEmpty || price == null || price <= 0) {
      AppSnackbar.show(
        'Error',
        'Please enter valid data.',
      );
      return;
    }

    if (selectedCategory == null) {
      AppSnackbar.show(
        'Error',
        'Please select a category.',
      );
      return;
    }

    // Existing product ki updated copy
    final updatedProduct = ProductModel(
      id: widget.product.id,
      ownerId: widget.product.ownerId,
      firestoreId: widget.product.firestoreId,

      title: title,
      description: widget.product.description,
      price: price,
      discountPercentage:
      widget.product.discountPercentage,
      rating: widget.product.rating,
      stock: widget.product.stock,
      brand: widget.product.brand,

      // Central category
      categoryId: selectedCategory!.id,
      categoryName: selectedCategory!.name,

      images: widget.product.images,
      thumbnail: widget.product.thumbnail,
      reviews: widget.product.reviews,
    );

    await firestoreProductController.updateProduct(
      updatedProduct,
    );

    // Only close when update succeeded
    if (firestoreProductController
        .errorMessage.value.isEmpty) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),

      body: Obx(() {
        final activeCategories =
            categoryController.activeCategories;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // PRODUCT TITLE
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Product Title',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // PRICE
              TextField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // CATEGORY
              DropdownButtonFormField<CategoryModel>(
                value: selectedCategory,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  hintText: 'Select a category',
                  border: OutlineInputBorder(),
                ),
                items: activeCategories
                    .map(
                      (category) =>
                      DropdownMenuItem<CategoryModel>(
                        value: category,
                        child: Text(category.name),
                      ),
                )
                    .toList(),
                onChanged: activeCategories.isEmpty
                    ? null
                    : (category) {
                  setState(() {
                    selectedCategory = category;
                  });
                },
              ),

              if (activeCategories.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'No active categories available.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // UPDATE BUTTON
              Obx(
                    () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                    firestoreProductController
                        .isLoading.value
                        ? null
                        : updateProduct,
                    child:
                    firestoreProductController
                        .isLoading.value
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      'Update Product',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}