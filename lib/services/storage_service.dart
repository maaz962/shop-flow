import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String tokenKey = 'accessToken';

  Future<void> saveToken(String token) async{
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(tokenKey);
  }

  Future<void> removeToken() async{
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(tokenKey);
  }

  Future<void> saveSignupUser({
    required String username,
    required String password,
}) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('signup_username', username);
    await prefs.setString('signup_password', password);
  }

  Future<String?> getSignupUsername() async{
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('signup_username');
  }

  Future<String?> getSignupPassword() async{
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('signup_password');
  }
}