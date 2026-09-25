import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/product_model.dart';
import '../services/firestore_service.dart';
import 'auth_controller.dart';
import 'package:shop_flow_app/app/utils/app_snackbar.dart';

class FirestoreProductController extends GetxController {
  final FirestoreService firestoreService = FirestoreService();
  final AuthController authController =
  Get.find<AuthController>();

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

  // Currently selected category name
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

  // Get all Firestore products
  Future<void> getProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fetchedProducts =
      await firestoreService.getProducts();

      allProducts.assignAll(fetchedProducts);

      // Apply current search/category filters
      _applyFilters();
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

  // Search products
  void searchProducts(String query) {
    searchQuery.value = query;

    _applyFilters();
  }

  // Filter products by category name
  void filterByCategory(String categoryName) {
    selectedCategory.value = categoryName;

    _applyFilters();
  }

  // Clear search
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';

    _applyFilters();
  }

  // Apply category + search filters
  void _applyFilters() {
    var filtered = allProducts.toList();

    // Category filter
    if (selectedCategory.value != 'All') {
      filtered = filtered
          .where(
            (product) =>
        product.categoryName.toLowerCase() ==
            selectedCategory.value.toLowerCase(),
      )
          .toList();
    }

    // Search filter
    final search =
    searchQuery.value.toLowerCase().trim();

    if (search.isNotEmpty) {
      filtered = filtered.where((product) {
        return product.title
            .toLowerCase()
            .contains(search) ||
            product.categoryName
                .toLowerCase()
                .contains(search) ||
            product.brand
                .toLowerCase()
                .contains(search) ||
            product.description
                .toLowerCase()
                .contains(search);
      }).toList();
    }

    // Update products even when result is empty
    products.assignAll(filtered);
  }

  // Create Product
  Future<void> createProduct({
    required String title,
    required double price,
    required String description,
    required double discountPercentage,
    required int stock,
    required String brand,

    // Central category information
    required String categoryId,
    required String categoryName,

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

      if (categoryId.trim().isEmpty) {
        AppSnackbar.show(
          'Category Required',
          'Please select a category',
        );
        return;
      }

      if (categoryName.trim().isEmpty) {
        AppSnackbar.show(
          'Category Required',
          'Please select a category',
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

        // Central category
        categoryId: categoryId,
        categoryName: categoryName,

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

      // Refresh seller's products
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
  Future<void> updateProduct(
      ProductModel product,
      ) async {
    try {
      if (product.firestoreId == null ||
          product.firestoreId!.isEmpty) {
        throw Exception(
          'Firestore document ID is missing',
        );
      }

      if (product.categoryId.trim().isEmpty) {
        throw Exception(
          'Category ID is missing',
        );
      }

      if (product.categoryName.trim().isEmpty) {
        throw Exception(
          'Category name is missing',
        );
      }

      isLoading.value = true;
      errorMessage.value = '';

      await firestoreService.updateProduct(
        product,
      );

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
  Future<void> deleteProduct(
      ProductModel product,
      ) async {
    try {
      final firestoreId = product.firestoreId;

      if (firestoreId == null ||
          firestoreId.isEmpty) {
        throw Exception(
          'Firestore document ID is missing',
        );
      }

      isLoading.value = true;
      errorMessage.value = '';

      await firestoreService.deleteProduct(
        firestoreId,
      );

      // Remove from seller's products
      myProducts.removeWhere(
            (p) => p.firestoreId == product.firestoreId,
      );

      // Remove from all products
      allProducts.removeWhere(
            (p) => p.firestoreId == product.firestoreId,
      );

      // Remove from currently displayed products
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