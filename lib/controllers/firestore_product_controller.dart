import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/firestore_service.dart';

class FirestoreProductController extends GetxController{
  final FirestoreService firestoreService = FirestoreService();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Firestore Products List
  final products = <ProductModel>[].obs;

  @override
  void onInit(){
    super.onInit();
    getProducts();
  }

  // Get/ Read Products
  Future<void> getProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fetchedProducts = await firestoreService.getProducts();

      products.assignAll(fetchedProducts);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Create Product
  Future<void> createProduct({
    required String title,
    required double price,
}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final product = ProductModel(
          id: 0,
          title: title,
          description: '',
          price: price,
          discountPercentage: 0,
          rating: 0,
          stock: 0,
          brand: '',
          category: '',
          images: [],
          thumbnail: '',
          reviews: [],
        firestoreId: null,
      );

      await firestoreService.createProduct(product);

      Get.snackbar('Success', 'Product created successfully',
      );

      await getProducts();
    } catch (e) {
      errorMessage.value = e.toString();

      Get.snackbar('Error', 'Failed to create product',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await firestoreService.updateProduct(product);

      Get.snackbar('Success', 'Product updated successfully',);

      // updated data dobara firestore sy read
      await getProducts();
    } catch (e) {
      errorMessage.value = e.toString();

      Get.snackbar('Error', 'Failed to update product',);
    } finally {
      isLoading.value = false;
    }
  }

  // Delete product
Future<void> deleteProduct(ProductModel product) async {
    try {
      if(product.firestoreId == null || product.firestoreId!.isEmpty) {
        throw Exception('Firestore document Id is missing');
      }
      isLoading.value = true;
      errorMessage.value = '';

      await firestoreService.deleteProduct(product.firestoreId!,);

      // UI sy b remove
      products.removeWhere(
          (p) => p.firestoreId == product.firestoreId,
      );

      Get.snackbar('Success', 'Product deleted successfully',);
    } catch (e) {
      errorMessage.value = e.toString();

      Get.snackbar('Error', 'Failed to delete product');
    } finally {
      isLoading.value = false;
    }
}
}