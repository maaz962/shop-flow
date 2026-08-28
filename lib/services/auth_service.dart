import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<Response> login({
    required String username,
    required String password,
}) async {
    final response = await _dio.post(
      '/auth/login',
      data: {
        'username': username,
        'password': password,
      },
    );
    return response;
  }

  Future<Response> signup({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
}) async {
    final response =  await _dio.post(
      '/users/add',
      data: {
        'username' : username,
        'email' : email,
        'password' : password,

      },
    );
    return response;
  }
}