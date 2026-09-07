import 'package:get/get.dart';
import '../models/product_model.dart';

class CartController extends GetxController{
  final cartItems = <ProductModel>[].obs;

  void addToCart(ProductModel product) {
    final existingIndex = cartItems.indexWhere(
        (item) => item.firestoreId == product.firestoreId,
    );

    if(existingIndex != -1){
      Get.snackbar('Cart',
      'Product is already in yout cart',
      );
      return;
    }
    cartItems.add(product);

    Get.snackbar('Cart',
        '${product.title} added to cart',
    );
  }

  void removeFromCart(ProductModel product) {
    cartItems.removeWhere(
        (item) => item.firestoreId == product.firestoreId,
    );
  }

  void clearCart() {
    cartItems.clear();
  }

  double get subtotal {
    double total = 0;

    for(final product in cartItems) {
      total += product.price;
    }

    return total;
  }

  int get itemCount {
    return cartItems.length;
  }

  bool isInCart(ProductModel product) {
    return cartItems.any(
        (item) => item.firestoreId == product.firestoreId,
    );
  }
}