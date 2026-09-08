import 'package:get/get.dart';

import '../models/product_model.dart';

class WishlistController extends GetxController {
  final wishlistProducts = <ProductModel>[].obs;

  // Add / remove product from wishlist
  void toggleWishlist(ProductModel product) {
    final productId = product.firestoreId;

    if (productId == null || productId.isEmpty) {
      Get.snackbar(
        'Wishlist',
        'Product ID is missing',
      );
      return;
    }

    final alreadyExists = wishlistProducts.any(
          (item) => item.firestoreId == productId,
    );

    if (alreadyExists) {
      wishlistProducts.removeWhere(
            (item) => item.firestoreId == productId,
      );
    } else {
      wishlistProducts.add(product);
    }
  }

  // Check whether product is favorite
  bool isFavorite(String productId) {
    return wishlistProducts.any(
          (item) => item.firestoreId == productId,
    );
  }
}