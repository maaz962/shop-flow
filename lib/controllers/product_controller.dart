import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductController extends GetxController{
  final ApiService apiService = ApiService();

  final products = <ProductModel>[].obs;

  final isLoading = false.obs;

  final errorMessage = ''.obs;

  @override
  void onInit(){
    super.onInit();

    fetchProducts();
  }

  Future<void> fetchProducts() async{
    try{
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiService.getProducts();

      final List<dynamic> data = response.data['products'];

      products.value = data
      .map(
          (json) => ProductModel.fromJson(json),
      )
      .toList();
    } catch (e) {
      errorMessage.value = e.toString();
    }finally {
      isLoading.value = false;
    }
  }
}