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

  Future<Response> getProducts({
    int limit = 10,
    int skip = 0,
  }) async {
    try{
      final response = await _dio.get(
          '/products',
        queryParameters: {
            'limit': limit,
          'skip': skip,
        },
      );

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

  Future<Response> updateProduct({
    required int id,
    required String title,
    required double price,
})async{
    try{
      final response = await _dio.put(
        '/products/$id',
        data: {
          'title' : title,
          'price' : price,
        },
      );

      return response;
    }
    on DioException catch (e) {
      throw Exception(
        e.message ?? 'Failed to update product',
      );
    }}

  Future<Response> patchProduct({
    required int id,

    required double price,
}) async {
    try{
      final response = await _dio.patch(
        '/products/$id',
        data: {
          // 'title' : title,
          'price' : price,
        },
      );

      return response;
    }
    on DioException catch(e) {
      throw Exception(
        e.message ?? 'Failed to patch product',
      );
    }
  }

  Future<Response> deleteProduct({
    required int id,
    // required double price,
}) async {
    try{
      final response = await _dio.delete(
        '/products/$id',
        // data: {
        //   'price': price,
        // },
      );
      return response;
    }
    on DioException catch(e) {
      throw Exception(
        e.message ?? 'Failed to delete Product',
      );
    }
  }

}