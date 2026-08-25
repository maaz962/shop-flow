import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductController extends GetxController{
  final ApiService apiService = ApiService();

  final products = <ProductModel>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  int currentPage = 1;
  final int limit = 10;

  int get skip => (currentPage -1 ) * limit;


  @override
  void onInit(){
    super.onInit();

    fetchProducts();
  }

  Future<void> fetchProducts() async{
    try{
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiService.getProducts(
        limit: 10,
        skip: 0,
      );

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

  Future<void> goToPage(int page) async {
    currentPage = page;

    await fetchProducts();
  }

  Future<void> createProduct({
    required String title,
    required double price,
}) async {
    try {
      final response = await apiService.createProduct(
          title: title,
        price: price,);

      final newProduct = ProductModel.fromJson(response.data);
      products.insert(0, newProduct);

    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> updateProduct({
    required int id,
    required String title,
    required double price,
}) async{
    try {
      final response = await apiService.updateProduct(
          id: id,
          title: title,
          price: price);

      final updateProduct = ProductModel.fromJson(response.data);

      final index = products.indexWhere(
          (product) => product.id == id,
      );

      if(index != -1){
        products[index] = updateProduct;
        products.refresh();
      }
    } catch (e) {
      errorMessage.value = e.toString();}}

  Future<void> patchProduct({
    required int id,
    required double price,
}) async {
    try{
      final response = await apiService.patchProduct(
          id: id,
          price: price);

      final patchProduct = ProductModel.fromJson(response.data);

      final index = products.indexWhere(
          (product) => product.id == id,
      );
      if (index != -1) {
        products[index] = ProductModel(
          id: products[index].id,
          title: products[index].title,
          description: products[index].description,
          price: price,
          discountPercentage:
          products[index].discountPercentage,
          rating: products[index].rating,
          stock: products[index].stock,
          brand: products[index].brand,
          category: products[index].category,
          thumbnail: products[index].thumbnail,
          images: products[index].images,
        );

        products.refresh();
      }
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }
  Future<void> deleteProduct(int id) async{
    try{
      await apiService.deleteProduct(id: id);

      products.removeWhere(
          (product) => product.id == id
      );
    }catch (e) {
      errorMessage.value = e.toString();
    }
  }


}