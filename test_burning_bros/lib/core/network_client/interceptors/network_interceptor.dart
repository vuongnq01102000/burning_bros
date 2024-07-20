import 'package:dio/dio.dart';

class NetworkInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        // Handle timeout
        break;
      case DioExceptionType.receiveTimeout:
        // Handle receive timeout
        break;
      case DioExceptionType.connectionError:
        // Handle response error
        DioException.connectionError(
            requestOptions: err.requestOptions, reason: 'Connection error');
        break;

      case DioExceptionType.sendTimeout:
        // Handle send timeout
        break;
      case DioExceptionType.cancel:
        // Handle cancel
        break;
      case DioExceptionType.unknown:
        // Handle other
        break;
      default:
        break;
    }
    super.onError(err, handler);
  }
}
