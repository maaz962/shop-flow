import 'package:get/get.dart';

import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductController extends GetxController {
  final ApiService apiService = ApiService();

  final products = <ProductModel>[].obs;

  // All products of current page
  final allProducts = <ProductModel>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  int currentPage = 1;
  final int limit = 10;

  int get skip => (currentPage - 1) * limit;

  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();

    fetchProducts();
  }

  // GET PRODUCTS
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiService.getProducts(
        limit: limit,
        skip: skip,
      );

      final List<dynamic> data = response.data['products'];

      final fetchedProducts = data
          .map(
            (json) => ProductModel.fromJson(json),
      )
          .toList();

      allProducts.assignAll(fetchedProducts);

      // Apply existing search after loading new page
      if (searchQuery.value.isEmpty) {
        products.assignAll(fetchedProducts);
      } else {
        searchProducts(searchQuery.value);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }


  // SEARCH
  void searchProducts(String query) {
    final search = query.trim().toLowerCase();

    searchQuery.value = search;

    if (search.isEmpty) {
      products.assignAll(allProducts);
      return;
    }

    final results = allProducts.where((product) {
      return product.title.toLowerCase().contains(searchQuery);
    }).toList();

    products.assignAll(results);
  }


  Future<void> goToPage(int page) async {
    if (page < 1) return;

    currentPage = page;

    await fetchProducts();
  }


  // POST
  Future<void> createProduct({
    required String title,
    required double price,
  }) async {
    try {
      final response = await apiService.createProduct(
        title: title,
        price: price,
      );

      final newProduct = ProductModel.fromJson(response.data);

      allProducts.insert(0, newProduct);

      searchProducts(searchQuery.value);
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  // PUT
  Future<void> updateProduct({
    required int id,
    required String title,
    required double price,
  }) async {
    try {
      final response = await apiService.updateProduct(
        id: id,
        title: title,
        price: price,
      );

      final updatedProduct = ProductModel.fromJson(response.data);

      final index = allProducts.indexWhere(
            (product) => product.id == id,
      );

      if (index != -1) {
        allProducts[index] = updatedProduct;
        allProducts.refresh();

        searchProducts(searchQuery.value);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }


  // PATCH
  Future<void> patchProduct({
    required int id,
    required double price,
  }) async {
    try {
      await apiService.patchProduct(
        id: id,
        price: price,
      );

      final index = allProducts.indexWhere(
            (product) => product.id == id,
      );

      if (index != -1) {
        allProducts[index] = ProductModel(
          id: allProducts[index].id,
          title: allProducts[index].title,
          description: allProducts[index].description,
          price: price,
          discountPercentage: allProducts[index].discountPercentage,
          rating: allProducts[index].rating,
          stock: allProducts[index].stock,
          brand: allProducts[index].brand,
          category: allProducts[index].category,
          thumbnail: allProducts[index].thumbnail,
          images: allProducts[index].images,
          reviews: allProducts[index].reviews,
          firestoreId: null,
        );

        allProducts.refresh();

        searchProducts(searchQuery.value);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }


  // DELETE
  Future<void> deleteProduct(int id) async {
    try {
      await apiService.deleteProduct(
        id: id,
      );

      allProducts.removeWhere(
            (product) => product.id == id,
      );

      products.removeWhere(
            (product) => product.id == id,
      );
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }
}