import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late final Dio dio;
  final _logger = Logger();

  void initialize() {
    final baseUrl = dotenv.env['BACK4APP_BASE_URL']!;
    final appId = dotenv.env['BACK4APP_APPLICATION_ID']!;
    final apiKey = dotenv.env['BACK4APP_REST_API_KEY']!;

    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          Headers.contentTypeHeader: ContentType.json,
          "X-Parse-Application-Id": appId,
          "X-Parse-REST-API-Key": apiKey,
          // "Content-Type": "application/json",
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.i("[Request] ${options.method} ${options.uri}");
          _logger.d("Headers: ${options.headers}");
          if (options.data != null) _logger.d("Data: ${options.data}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.i("[Response] ${response.statusCode}: ${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          _logger.e("[Error] ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }

  Dio getAuthorizedClient(String sessionToken) {
    final client = Dio(BaseOptions(headers: dio.options.headers));
    client.options.headers["X-Parse-Session-Token"] = sessionToken;
    client.options.baseUrl = dio.options.baseUrl;
    return client;
  }
}
