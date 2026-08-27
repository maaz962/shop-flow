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
}