import 'package:get/get.dart';
import 'package:shop_flow_app/services/storage_service.dart';
import '../services/auth_service.dart';


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

    if(savedToken != null && savedToken.isNotEmpty){
      token.value = savedToken;
    }
  }

  Future<bool> login({
    required String username,
    required String password,
}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // check if user has signed up
      final savedUsername = await storageService.getSignupUsername();
      final savedPassword = await storageService.getSignupPassword();

      if(savedUsername == null || savedPassword == null){
        errorMessage.value = 'Please signup first';
        return false;
      }

      // check signup credentials
      if(username != savedUsername || password != savedPassword){
        errorMessage.value = 'Invalid username or password';
        return false;
      }

      // Login successful // create local session token
      token.value = 'local_token_${DateTime.now().millisecondsSinceEpoch}';

      await storageService.saveToken(token.value);
      print('Login successful');
      print('Token saved: ${token.value}');
      return true;
      // login API
      final response = await authService.login(
        username: username,
        password: password,
      );

      final accessToken = response.data['accessToken'];
      if(accessToken == null || accessToken.toString().isEmpty){
        errorMessage.value = 'Login Failed: Token not received';
        return false;
      }
      token.value = accessToken.toString();

      await storageService.saveToken(token.value,);

       print('Token saved: ${token.value}');

       // successful login
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signup({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      //confirm password validation
      if(password != confirmPassword){
        errorMessage.value = 'Passwords do not match';
        return false;
      }

      // signup API
      final response = await authService.signup(
        username: username,
        email: email,
        password : password,
        confirmPassword: '',
      );
      print('Signup successful: ${response.data}');

      // save signup user locally
      await storageService.saveSignupUser(username: username, password: password);
      return true;
    }
    catch (e) {
      errorMessage.value = e.toString();

      return false;
    }
    finally {
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