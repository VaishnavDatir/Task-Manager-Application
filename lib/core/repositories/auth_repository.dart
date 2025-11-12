import 'dart:async';

import 'package:dio/dio.dart';

import '../models/user_model.dart';
import '../network/api_custom_header.dart' show ApiCustomHeaders;
import '../network/api_endpoints.dart';
import '../utils/logger.dart';

class AuthRepository {
  final Dio _dio;
  AuthRepository(this._dio);


  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  /// Login user
  Future<UserModel?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'username': username, 'password': password},
      );

      log.i('Login successful');
      log.d(response.data);

      final data = response.data;

      _currentUser = UserModel.fromJson(data);
      return _currentUser;
    } on DioException catch (e) {
      final message = e.response?.data['error'] ?? 'Login failed';
      log.e('Login failed: $message');
      throw AuthException(message);
    }
  }

  /// Signup user
  Future<UserModel?> signup({
    required String username,
    required String password,
    required String fullName,
    required String phone,
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.signup,
        data: {
          'username': username,
          'password': password,
          'email': email,
          'userFullName': fullName,
          'userMobileNo': phone,
        },
      );

      log.i('Signup successful');
      log.d(response.data.toString());

      final data = response.data;

      _currentUser = UserModel.fromJson(data);

      return _currentUser;
    } on DioException catch (e) {
      final message = e.response?.data['error'] ?? 'Signup failed';
      log.e('Signup failed: $message');
      throw AuthException(message);
    }
  }

  /// Fetch current user (using session)
  Future<UserModel?> getCurrentUser(String sessionToken) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.me,
        options: Options(
          headers: {ApiCustomHeaders.xParseSessionToken: sessionToken},
        ),
      );

      log.i('Current user fetched');
      _currentUser = UserModel.fromJson(response.data);
      return _currentUser;
    } on DioException catch (e) {
      final message = e.response?.data['error'] ?? 'Fetch user failed';
      log.e('❌ Fetch current user failed: $message');
      throw AuthException(message);
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      if (_currentUser != null) {
        await _dio.post(
          ApiEndpoints.logout,
          options: Options(
            headers: {
              ApiCustomHeaders.xParseSessionToken: _currentUser!.sessionToken,
            },
          ),
        );
      }

      log.i('Logout successful');
    } catch (e) {
      log.w('Logout API call failed (ignoring): $e');
    } finally {
      _currentUser = null;
    }
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}
