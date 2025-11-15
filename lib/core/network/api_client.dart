import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../utils/logger.dart';
import 'api_custom_header.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio dio;

  ApiClient._internal() {
    _setupDio();
  }

  void _setupDio() {
    final baseUrl = dotenv.env['BACK4APP_BASE_URL']!;
    final appId = dotenv.env['BACK4APP_APPLICATION_ID']!;
    final apiKey = dotenv.env['BACK4APP_CLIENT_API_KEY']!;

    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          Headers.contentTypeHeader: ContentType.json.value,
          ApiCustomHeaders.xParseApplicationId: appId,
          ApiCustomHeaders.xParseClientKey: apiKey,
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log.i("[Request] ${options.method} ${options.uri}");
          log.d("Headers: ${options.headers}");
          if (options.data != null) log.d("Data: ${options.data}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log.i("[Response] ${response.statusCode}: ${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          log.e("[Error] api response: ${e.response}");
          log.e("[Error] ${e.message}");
          return handler.next(e);
        },
      ),
    );

    log.i("ApiClient initialized with $baseUrl");
  }
}
