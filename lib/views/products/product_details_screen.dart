import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/product_model.dart';
import '../../app/routes/app_routes.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Product HomeScreen se receive hoga
    final ProductModel product = Get.arguments;

    // Original price calculate karna
    double originalPrice =
        product.price /
            (1 - product.discountPercentage / 100);

    if (product.discountPercentage > 0 && product.discountPercentage < 100) {
      originalPrice = product.price / (1 - product.discountPercentage / 100);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),

        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Get.toNamed(
        //         AppRoutes.editProduct,
        //         arguments: product,
        //       );
        //     },
        //     icon: const Icon(Icons.edit),
        //   ),
        // ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Product Image
            SizedBox(
              width: double.infinity,
              height: 350,
              child: product.thumbnail.isNotEmpty
          ? Image.network(
                product.thumbnail,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace){
                  return const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                  );
                },
              )
              : const Center(
                child: Icon(Icons.image_not_supported_outlined,
                size: 80,
                color: Colors.grey,),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              product.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // Rating
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),

                const SizedBox(width: 5),

                Text(
                  '${product.rating}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  '${product.reviews.length} Reviews',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Price
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            // Original Price + Discount
            Row(
              children: [
                Text(
                  '\$${originalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    decoration:
                    TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(width: 10),

                Text(
                  '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Shipping
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.local_shipping,
                ),
                title: const Text(
                  'Free Shipping',
                ),
                subtitle: const Text(
                  'Delivery in 2-4 days',
                ),
              ),
            ),

            // Product Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Product Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text('Brand: ${product.brand}'),
                    Text('Category: ${product.category}'),
                    Text('Stock: ${product.stock}'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Description
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              product.description,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 30),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Cart later
                    },
                    child: const Text(
                      'Add to Cart',
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Buy Now later
                    },
                    child: const Text(
                      'Buy Now',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}