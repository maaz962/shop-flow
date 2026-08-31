import 'package:get/get.dart';
import '../models/product_model.dart';

class WishlistController extends GetxController{
  final wishlistProducts = <ProductModel>[].obs;

  // add / remove product
  void toggleWishlist(ProductModel product){
    final alreadyExists = wishlistProducts.any(
        (item) => item.id == product.id,
    );

    if(alreadyExists) {
      wishlistProducts.removeWhere(
          (item) => item.id == product.id,
      );
    } else {
      wishlistProducts.add(product);
    }

  }

  // check whether product is already fav
bool isFavorite(int productId) {
    return wishlistProducts.any(
        (item) => item.id == productId,
    );
}
}