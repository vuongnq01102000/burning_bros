import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  String? _accessToken;

  void setAccessToken(String token) {
    _accessToken = token;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_accessToken != null) {
      options.headers['Authorization'] = 'Bearer $_accessToken';
    }
    super.onRequest(options, handler);
  }
}
