import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/utils/app_snackbar.dart';
import '../../controllers/firestore_product_controller.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() =>
      _AddProductScreenState();
}

class _AddProductScreenState
    extends State<AddProductScreen> {
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final discountController = TextEditingController();
  final stockController = TextEditingController();
  final brandController = TextEditingController();
  final categoryController = TextEditingController();
  final thumbnailController = TextEditingController();

  final firestoreProductController =
  Get.find<FirestoreProductController>();

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    discountController.dispose();
    stockController.dispose();
    brandController.dispose();
    categoryController.dispose();
    thumbnailController.dispose();

    super.dispose();
  }

  Future<void> createProduct() async {
    final title = titleController.text.trim();
    final description =
    descriptionController.text.trim();

    final price =
    double.tryParse(priceController.text.trim());

    final discount =
    double.tryParse(
      discountController.text.trim(),
    );

    final stock =
    int.tryParse(stockController.text.trim());

    final brand = brandController.text.trim();
    final category = categoryController.text.trim();
    final thumbnail =
    thumbnailController.text.trim();

    // VALIDATION
    if (title.isEmpty) {
      AppSnackbar.show(
        'Error',
        'Please enter product title',
      );
      return;
    }

    if (description.isEmpty) {
      AppSnackbar.show(
        'Error',
        'Please enter product description',
      );
      return;
    }

    if (price == null || price <= 0) {
      AppSnackbar.show(
        'Error',
        'Please enter a valid price',
      );
      return;
    }

    if (discount == null ||
        discount < 0 ||
        discount > 100) {
      AppSnackbar.show(
        'Error',
        'Discount must be between 0 and 100',
      );
      return;
    }

    if (stock == null || stock < 0) {
      AppSnackbar.show(
        'Error',
        'Please enter a valid stock',
      );
      return;
    }

    if (brand.isEmpty) {
      AppSnackbar.show(
        'Error',
        'Please enter product brand',
      );
      return;
    }

    if (category.isEmpty) {
      AppSnackbar.show(
        'Error',
        'Please enter product category',
      );
      return;
    }

    if (thumbnail.isEmpty) {
      AppSnackbar.show(
        'Error',
        'Please enter product image URL',
      );
      return;
    }

    // CREATE PRODUCT
  await firestoreProductController.createProduct(
      title: title,
      description: description,
      price: price,
      discountPercentage: discount,
      stock: stock,
      brand: brand,
      category: category,
      thumbnail: thumbnail,
    );

    // CLEAR FORM
       if (!firestoreProductController
        .isLoading.value &&
        firestoreProductController
            .errorMessage.value.isEmpty) {
      titleController.clear();
      descriptionController.clear();
      priceController.clear();
      discountController.clear();
      stockController.clear();
      brandController.clear();
      categoryController.clear();
      thumbnailController.clear();

      Get.back();
    }
  }

  InputDecoration fieldDecoration(
      String label,
      String hint,
      ) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: const OutlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // TITLE
            TextField(
              controller: titleController,
              textInputAction:
              TextInputAction.next,
              decoration: fieldDecoration(
                'Product Title',
                'e.g. Wireless Headphones',
              ),
            ),

            const SizedBox(height: 16),

            // DESCRIPTION
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: fieldDecoration(
                'Description',
                'Enter product description',
              ),
            ),

            const SizedBox(height: 16),

            // PRICE
            TextField(
              controller: priceController,
              keyboardType:
              const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: fieldDecoration(
                'Price',
                'e.g. 49.99',
              ),
            ),

            const SizedBox(height: 16),

            // DISCOUNT
            TextField(
              controller: discountController,
              keyboardType:
              const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: fieldDecoration(
                'Discount (%)',
                'e.g. 10',
              ),
            ),

            const SizedBox(height: 16),

            // STOCK
           TextField(
              controller: stockController,
              keyboardType:
              TextInputType.number,
              decoration: fieldDecoration(
                'Stock',
                'e.g. 50',
              ),
            ),

            const SizedBox(height: 16),

            // BRAND
           TextField(
              controller: brandController,
              textInputAction:
              TextInputAction.next,
              decoration: fieldDecoration(
                'Brand',
                'e.g. Sony',
              ),
            ),

            const SizedBox(height: 16),

            // CATEGORY
            TextField(
              controller: categoryController,
              textInputAction:
              TextInputAction.next,
              decoration: fieldDecoration(
                'Category',
                'e.g. Electronics',
              ),
            ),

            const SizedBox(height: 16),

            // IMAGE URL
             TextField(
              controller: thumbnailController,
              keyboardType:
              TextInputType.url,
              decoration: fieldDecoration(
                'Product Image URL',
                'https://example.com/image.jpg',
              ),
            ),

            const SizedBox(height: 24),

            // CREATE BUTTON
           Obx(
                  () => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed:
                  firestoreProductController
                      .isLoading.value
                      ? null
                      : createProduct,
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
                    'Create Product',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}