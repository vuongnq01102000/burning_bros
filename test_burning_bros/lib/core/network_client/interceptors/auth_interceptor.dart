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

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token hết hạn, có thể thực hiện refresh token ở đây
      // Ví dụ:
      // await refreshToken();
      // Sau đó retry request
      // final cloneReq = await _retry(err.requestOptions);
      // return handler.resolve(cloneReq);
    }
    return super.onError(err, handler);
  }
}