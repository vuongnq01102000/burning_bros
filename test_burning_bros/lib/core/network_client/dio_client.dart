import 'package:dio/dio.dart';
import 'package:test_burning_bros/app_config.dart';

import 'package:test_burning_bros/core/network_client/interceptors/auth_interceptor.dart';
import 'package:test_burning_bros/core/network_client/interceptors/network_interceptor.dart';

class DioClient {
  final Dio _dio = Dio();
  final AppConfig config;
  final AuthInterceptor authInterceptor = AuthInterceptor();

  DioClient(this.config) {
    _dio.options.baseUrl = config.baseUrl;
    _dio.options.headers = config.headers;
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(authInterceptor);
    _dio.interceptors.add(NetworkInterceptor());
    _dio.interceptors
        .add(LogInterceptor(requestBody: true, responseBody: true));
  }

  // Set access token for interceptor to add to request headers if needed
  void setAccessToken(String token) {
    authInterceptor.setAccessToken(token);
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Thêm các phương thức khác như put, delete, etc. tương tự

  Exception _handleError(error) {
    if (error is DioException) {
      // Xử lý các loại lỗi Dio
      return Exception(error.message);
    }
    return Exception('Có lỗi xảy ra');
  }
}
