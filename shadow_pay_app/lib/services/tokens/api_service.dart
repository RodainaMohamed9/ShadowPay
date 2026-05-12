import 'package:dio/dio.dart';
import 'package:shadow_pay_app/services/tokens/token_storage.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://jackeline-cibarious-supergallantly.ngrok-free.dev/api',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        "ngrok-skip-browser-warning": "true",
      },
      
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await TokenStorage.getAccessToken();
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final refreshed = await _refreshAccessToken();

          if (refreshed) {
            final newToken = await TokenStorage.getAccessToken();
            final requestOptions = error.requestOptions;
            requestOptions.headers["Authorization"] = "Bearer $newToken";

            final response = await dio.fetch(requestOptions);
            return handler.resolve(response);
          }
        }
        return handler.next(error);
      },
    ));
  }
}

Future<bool> _refreshAccessToken() async {
  try {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null) return false;

// I will Edit this
    final response = await Dio().post(
    'https://jackeline-cibarious-supergallantly.ngrok-free.dev/api/RefreshToken/refresh-token', 
      data: {"token": refreshToken},
      options: Options(headers: {"ngrok-skip-browser-warning": "true"}),

    );
    final newAccessToken = response.data["accessToken"];
    final newRefreshToken = response.data["refreshToken"];

    if (newAccessToken != null && newRefreshToken != null) {
      await TokenStorage.saveAccessToken(newAccessToken);
      await TokenStorage.saveRefreshToken(newRefreshToken);
      return true;
    }

    return false;
  } catch (e) {
    print("refresh failed: $e");
    return false;
  }
}
