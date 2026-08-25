import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type' : 'application/json',
      },
    ),
  );

  Future<Response> getProducts() async {
    try{
      final response = await _dio.get('/products');

      return response;
    } on DioException catch (e) {
      throw Exception(
        e.message ?? 'Something went wrong',
      );
    }
  }

  Future<Response> createProduct({
    required String title,
    required double price,
}) async {
    try {
      final response = await _dio.post(
        '/product/add',
        data: {
          'title': title,
          'price': price,
        },
      );

      return response;
    } on DioException catch (e) {
      throw Exception(
        e.message ?? 'Failed to create product',
      );
    }
  }

  Future<>
}