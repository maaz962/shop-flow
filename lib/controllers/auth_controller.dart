import 'package:get/get.dart';
import 'package:shop_flow_app/services/storage_service.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../app/routes/app_routes.dart';

class AuthController extends GetxController{
  final AuthService authService = AuthService();
  final StorageService storageService = StorageService();

  final isLoading = false.obs;
  final token = ''.obs;
  final errorMessage = ''.obs;

  @override
  void onInit(){
    super.onInit();

    loadToken();
  }

  Future<void> loadToken() async {
    final savedToken = await storageService.getToken();

    if(savedToken != null){
      token.value = savedToken;
    }
  }

  Future<void> login({
    required String username,
    required String password,
}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await authService.login(
        username: username,
        password: password,
      );

      token.value = response.data['accessToken'];

      await storageService.saveToken(token.value,);

       print('Token saved: ${token.value}');
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async{
    await storageService.removeToken();

    token.value = '';
  }

  Future<bool> isLoggedIn() async {
    final savedToken = await storageService.getToken();
    print('Saved Token: $savedToken');

    if(savedToken != null && savedToken.isNotEmpty){
      token.value = savedToken;
      return true;
    }
    return false;
  }
}