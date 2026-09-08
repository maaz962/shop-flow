import 'package:get/get.dart';

import '../models/product_model.dart';

class CartController extends GetxController {
  final cartItems = <ProductModel>[].obs;

  final quantities = <String, int>{}.obs;

  void addToCart(ProductModel product) {
    final productId = product.firestoreId;

    if (productId == null || productId.isEmpty) {
      Get.snackbar(
        'Cart',
        'Product ID is missing',
      );
      return;
    }

    if (product.stock <= 0) {
      Get.snackbar(
        'Cart',
        'This product is out of stock',
      );
      return;
    }

    final existingIndex = cartItems.indexWhere(
          (item) => item.firestoreId == productId,
    );

    if (existingIndex != -1) {
      increaseQuantity(product);
      return;
    }

    cartItems.add(product);
    quantities[productId] = 1;

    Get.snackbar(
      'Cart',
      '${product.title} added to cart',
    );
  }

  void increaseQuantity(ProductModel product) {
    final productId = product.firestoreId;

    if (productId == null || productId.isEmpty) {
      return;
    }

    final currentQuantity =
        quantities[productId] ?? 1;

    if (currentQuantity >= product.stock) {
      Get.snackbar(
        'Cart',
        'You cannot add more than available stock',
      );
      return;
    }

    quantities[productId] = currentQuantity + 1;
    quantities.refresh();
  }

  void decreaseQuantity(ProductModel product) {
    final productId = product.firestoreId;

    if (productId == null || productId.isEmpty) {
      return;
    }

    final currentQuantity =
        quantities[productId] ?? 1;

    if (currentQuantity <= 1) {
      removeFromCart(product);
      return;
    }

    quantities[productId] = currentQuantity - 1;
    quantities.refresh();
  }

  void removeFromCart(ProductModel product) {
    final productId = product.firestoreId;

    if (productId == null || productId.isEmpty) {
      return;
    }

    cartItems.removeWhere(
          (item) => item.firestoreId == productId,
    );

    quantities.remove(productId);
    quantities.refresh();
  }

  void clearCart() {
    cartItems.clear();
    quantities.clear();
  }

  int getQuantity(ProductModel product) {
    final productId = product.firestoreId;

    if (productId == null || productId.isEmpty) {
      return 0;
    }

    return quantities[productId] ?? 1;
  }

  double get subtotal {
    double total = 0;

    for (final product in cartItems) {
      final quantity = getQuantity(product);

      total += product.price * quantity;
    }

    return total;
  }

  int get itemCount {
    int total = 0;

    for (final product in cartItems) {
      total += getQuantity(product);
    }

    return total;
  }

  bool isInCart(ProductModel product) {
    return cartItems.any(
          (item) =>
      item.firestoreId == product.firestoreId,
    );
  }
}