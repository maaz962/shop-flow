import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/product_model.dart';
import '../../controllers/firestore_product_controller.dart';

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

  final firestoreProductController = Get.find<FirestoreProductController>();

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

    // Existing product ki copy bnaty hn:
    final updatedProduct = ProductModel(
        id: widget.product.id,
        ownerId: widget.product.ownerId,
        firestoreId: widget.product.firestoreId,
        title: title,
        description: widget.product.description,
        price: price,
        discountPercentage: widget.product.discountPercentage,
        rating: widget.product.rating,
        stock: widget.product.stock,
        brand: widget.product.brand,
        category: widget.product.category,
        images: widget.product.images,
        thumbnail: widget.product.thumbnail,
        reviews: widget.product.reviews,
        );

    await firestoreProductController.updateProduct(updatedProduct);

    Get.back();

    // Get.snackbar('Success', 'Product updated successfully.');
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

         ],
       ),),
    );
  }
}