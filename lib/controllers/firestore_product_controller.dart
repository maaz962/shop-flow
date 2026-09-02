import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/firestore_service.dart';

class FirestoreProductController extends GetxController{
  final FirestoreService firestoreService = FirestoreService();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

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
      );

      await firestoreService.createProduct(product);

      Get.snackbar('Success', 'Product created successfully',
      );
    } catch (e) {
      errorMessage.value = e.toString();

      Get.snackbar('Error', 'Failed to create product',
      );
    } finally {
      isLoading.value = false;
    }
  }
}