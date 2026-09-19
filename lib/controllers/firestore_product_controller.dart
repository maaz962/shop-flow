import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/product_model.dart';
import '../services/firestore_service.dart';
import 'auth_controller.dart';
import 'package:shop_flow_app/app/utils/app_snackbar.dart';

class FirestoreProductController extends GetxController {
  final FirestoreService firestoreService = FirestoreService();
  final AuthController authController = Get.find<AuthController>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // All Firestore products
  // Used by Home / Customer side
  final products = <ProductModel>[].obs;
  final allProducts = <ProductModel>[].obs;

  // Logged-in seller's products
  // Used by My Products / Seller Dashboard
  final myProducts = <ProductModel>[].obs;

  // Search text
  final searchQuery = ''.obs;
  final searchController = TextEditingController();

  final selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    getProducts();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  List<String> get categories {
    final unique = allProducts
        .map((p) => p.category.trim())
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList();
    unique.sort();
    return['All',  ...unique];
  }

  // Get all Firestore products
  Future<void> getProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fetchedProducts = await firestoreService.getProducts();

      allProducts.assignAll(fetchedProducts);
      products.assignAll(fetchedProducts);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Get only logged-in seller's products
  Future<void> getMyProducts() async {
    try {
      final uid = authController.user.value?.uid;

      if (uid == null) {
        errorMessage.value = 'User is not logged in';
        return;
      }

      isLoading.value = true;
      errorMessage.value = '';

      final fetchedProducts =
      await firestoreService.getProductsByOwner(uid);

      myProducts.assignAll(fetchedProducts);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Search filter from all products
  void searchProducts(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = allProducts.toList();

    if(selectedCategory.value != 'All') {
      filtered = filtered
          .where((p) =>
      p.category.toLowerCase() == selectedCategory.value.toLowerCase())
          .toList();
    }

    if(searchQuery.trim().isNotEmpty) {
      final search = searchQuery.value.toLowerCase().trim();
      filtered = filtered.where((product) {

        final title = product.title.toLowerCase();
        final category = product.category.toLowerCase();
        final brand = product.brand.toLowerCase();

        return title.contains(search) ||
            category.contains(search) ||
            brand.contains(search);
      }).toList();

      products.assignAll(filtered);
    }
      }



  // Create Product
  Future<void> createProduct({
    required String title,
    required double price,
    required String description,
    required double discountPercentage,
    required int stock,
    required String brand,
    required String category,
    required String thumbnail,
    List<String> images = const [],
  }) async {
    try {
      final uid = authController.user.value?.uid;

      if (uid == null) {
        AppSnackbar.show(
          'Login Required',
          'Please login first',
        );
        return;
      }

      isLoading.value = true;
      errorMessage.value = '';

      final product = ProductModel(
        id: 0,
        title: title,
        description: description,
        price: price,
        discountPercentage: discountPercentage,
        rating: 0,
        stock: stock,
        brand: brand,
        category: category,
        images: images,
        thumbnail: thumbnail,
        reviews: [],
        firestoreId: null,
        ownerId: uid,
      );

      await firestoreService.createProduct(product);

      AppSnackbar.show(
        'Success',
        'Product created successfully',
      );

      // Refresh ALL products for Home
      await getProducts();

      // Refresh only seller's products
      await getMyProducts();
    } catch (e) {
      errorMessage.value = e.toString();

      AppSnackbar.show(
        'Error',
        'Failed to create product',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update Product
  Future<void> updateProduct(ProductModel product) async {
    try {
      if (product.firestoreId == null ||
          product.firestoreId!.isEmpty) {
        throw Exception(
          'Firestore document ID is missing',
        );
      }

      isLoading.value = true;
      errorMessage.value = '';

      await firestoreService.updateProduct(product);

      AppSnackbar.show(
        'Success',
        'Product updated successfully',
      );

      // Refresh ALL products
      await getProducts();

      // Refresh seller's products
      await getMyProducts();
    } catch (e) {
      errorMessage.value = e.toString();

      AppSnackbar.show(
        'Error',
        'Failed to update product',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Delete Product
  Future<void> deleteProduct(ProductModel product) async {
    try {
      final firestoreId = product.firestoreId;

      if (firestoreId == null || firestoreId.isEmpty) {
        throw Exception(
          'Firestore document ID is missing',
        );
      }

      isLoading.value = true;
      errorMessage.value = '';

      await firestoreService.deleteProduct(firestoreId);

      // Remove from seller's products
      myProducts.removeWhere(
            (p) => p.firestoreId == product.firestoreId,
      );

      // Remove from all products
      products.removeWhere(
            (p) => p.firestoreId == product.firestoreId,
      );

      AppSnackbar.show(
        'Success',
        'Product deleted successfully',
      );
    } catch (e) {
      errorMessage.value = e.toString();

      AppSnackbar.show(
        'Error',
        'Failed to delete product',
      );
    } finally {
      isLoading.value = false;
    }
  }

}