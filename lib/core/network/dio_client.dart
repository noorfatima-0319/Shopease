import 'package:dio/dio.dart';

import '../constants/app_constants.dart';

// Single shared Dio instance. Base URL and timeouts live in one place
// so every data source talks to the API the same way.
class DioClient {
  final Dio dio;

  DioClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: AppConstants.apiBaseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
          ),
        );
}
