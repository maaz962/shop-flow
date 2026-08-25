import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../models/product_model.dart';

class EditProductScreen extends StatefulWidget{
  final ProductModel product;

  const EditProductScreen({
    super.key,
    required this.product,
});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late final TextEditingController titleController;
  late final TextEditingController priceController;

  final productController = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.product.title,
    );

    priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
  }

  @override
  void dispose(){
    titleController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> updateProduct() async {
    final title = titleController.text.trim();
    final price = double.tryParse(
      priceController.text.trim(),
    );

    if(title.isEmpty || price == null) {
      Get.snackbar(
        'Error', 'Please enter valid data.',
      );
      return;
    }

    await productController.updateProduct(
      id: widget.product.id,
      title: title,
      price: price,
    );

    Get.back();

    Get.snackbar('Success', 'Product updated successfully.');
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),

      body: Padding(padding: const EdgeInsets.all(16),
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

          const SizedBox(height: 24,),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: updateProduct,
                child: const Text('Update Product'),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () async {
                final price = double.tryParse(
                  priceController.text.trim(),
                );
                if(price == null){
                  Get.snackbar('error', 'Please enter a valid price.');
                  return;
                }
                await productController.patchProduct(
                    id: widget.product.id,
                    price: price);
                Get.back();

                Get.snackbar('Success',
                'Price updated using patch');
              },
              child: const Text('Update price with patch'),
            ),
          ),
        ],
      ),),
    );
  }
}