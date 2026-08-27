import 'package:dio/dio.dart';
import 'storage_service.dart';


class ApiService {
  final StorageService storageService = StorageService();


  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception(
          'Connection timeout. Please try again.',
        );

      case DioExceptionType.receiveTimeout:
        return Exception(
          'Server took too long to respond.',
        );

      case DioExceptionType.connectionError:
        return Exception(
          'No Internet connection.',
        );

      case DioExceptionType.badResponse:
        return Exception(
          'Server error: ${e.response?.statusCode}',
        );

      default:
        return Exception(
          'Something went wrong.',
        );
    }
  }

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

  ApiService(){
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storageService.getToken();

          if(token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          print(
            'REQUEST: ${options.method} ${options.uri}',
          );
          print(
            'HEADERS: ${options.headers}',
          );

          handler.next(options);
        },

        onResponse: (response, handler){
          print('RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',);

          handler.next(response);
        },

        onError: (error, handler){
          print('ERROR: ${error.requestOptions.uri}',);

          print('MESSAGE: ${error.message}',);

          handler.next(error);
        },
      ),
    );
  }


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
      throw _handleDioException(e);
      // throw Exception(
      //   e.message ?? 'Something went wrong',
      // );


      // switch (e.type) {
      //   case DioExceptionType.connectionTimeout:
      //     throw Exception(
      //       'Connection timeout. Please try again.',
      //     );
      //
      //   case DioExceptionType.receiveTimeout:
      //     throw Exception(
      //       'Server took too long to respond',
      //     );
      //
      //   case DioExceptionType.connectionError:
      //     throw Exception(
      //       'No Internet connection.',
      //     );
      //
      //   case DioExceptionType.badResponse:
      //     throw Exception(
      //       'Server error: ${e.response?.statusCode}',
      //     );
      //
      //   default:
      //     throw Exception(
      //       'Something went wrong.',
      //     );
      // }

      // throw Exception(
      //   'Unexpected error occurred.',
      // );
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
      // throw Exception(
      //   e.message ?? 'Failed to create product',
      // );
      throw _handleDioException(e);
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

      throw _handleDioException(e);
      // throw Exception(
      //   e.message ?? 'Failed to delete Product',
      // );
    }
  }

}