import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/wishlist_controller.dart';

class WishlistScreen extends StatelessWidget{
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final wishlistController = Get.find<WishlistController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
      ),

      body: Obx(() {
        if (wishlistController.wishlistProducts.isEmpty){
          return const Center(
            child: Text ('Your wishlist is empty ❤️',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
            ),

          );
        }

        return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: wishlistController.wishlistProducts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.68,
            ),
            itemBuilder: (context, index){
              final product = wishlistController.wishlistProducts[index];

              return Card(
                clipBehavior: Clip.antiAlias,
                elevation: 3,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex:5 ,
                        child: SizedBox(
                          width: double.infinity,
                          child: Image.network(
                            product.thumbnail,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 40,
                                ),
                              );
                            },
                          ),
                        ),
                    ),

                    // Product Info
                    Expanded(
                      flex: 4,
                      child: Padding(padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //title
                          Text(product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),),

                          const SizedBox(height: 6,),
                          //price
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const Spacer(),
                          // remove from wishlist
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(onPressed: () {
                              wishlistController.toggleWishlist(product);
                            }, icon: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),),
                          ),

                        ],
                      ),),
                    )

                  ],
                ),
              );
            },
        );
      }),
    );
  }
}