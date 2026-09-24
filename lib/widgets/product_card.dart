import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/routes/app_routes.dart';
import '../controllers/auth_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/wishlist_controller.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final cartController = Get.find<CartController>();
    final wishlistController = Get.find<WishlistController>();

    double originalPrice = product.price;

    if (product.discountPercentage > 0 &&
        product.discountPercentage < 100) {
      originalPrice =
          product.price / (1 - product.discountPercentage / 100);
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      child: InkWell(
        onTap: () {
          Get.toNamed(
            AppRoutes.productDetails,
            arguments: product,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // IMAGE + BADGES
            AspectRatio(
              aspectRatio: 1.25,
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: product.thumbnail.isNotEmpty
                        ? Image.network(
                      product.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (
                          context,
                          error,
                          stackTrace,
                          ) {
                        return const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                        : const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  // DISCOUNT BADGE
                  if (product.discountPercentage > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // WISHLIST HEART
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Obx(
                          () {
                        final isFavorite =
                        wishlistController.isFavorite(
                          product.firestoreId ?? '',
                        );

                        return Material(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: const CircleBorder(),
                          child: IconButton(
                            onPressed: () {
                              wishlistController.toggleWishlist(product);
                            },
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                              size: 21,
                            ),
                            padding: const EdgeInsets.all(7),
                            constraints: const BoxConstraints(),
                            tooltip: isFavorite
                                ? 'Remove from wishlist'
                                : 'Add to wishlist',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // PRODUCT INFO
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TITLE
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // CURRENT PRICE
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // ORIGINAL PRICE
                  if (product.discountPercentage > 0)
                    Text(
                      '\$${originalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),

                  const SizedBox(height: 4),

                  // RATING + STOCK
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
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          product.stock > 0
                              ? 'In stock'
                              : 'Out of stock',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: product.stock > 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // SHIPPING + ADD TO CART
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.local_shipping_outlined,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            const Flexible(
                              child: Text(
                                'Free Shipping',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 4),

                      SizedBox(
                        height: 32,
                        child: ElevatedButton.icon(
                          onPressed: product.stock <= 0
                              ? null
                              : () {
                            // Guest user
                            if (!authController.isLoggedIn) {
                              Get.toNamed(AppRoutes.login);
                              return;
                            }

                            // Logged-in user
                            cartController.addToCart(product);
                          },
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                            size: 15,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}