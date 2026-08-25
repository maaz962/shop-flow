import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../controllers/product_controller.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen>{
  final titleController = TextEditingController();
  final priceController = TextEditingController();

  final productController = Get.find<ProductController>();

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> createProduct() async {
    final title = titleController.text.trim();
    final price = double.tryParse(priceController.text.trim());

    if(title.isEmpty || price == null) {
      Get.snackbar('Error', 'Please enter a valid title & price.');
      return;
    }

    await productController.createProduct(title: title, price: price);

    Get.snackbar('Success', 'Product created successfully',);

    titleController.clear();
    priceController.clear();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Product Title',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: createProduct,
                  child: const Text('Create Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}