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

  void refreshCurrentUserData(UserModel? currUser) {
    _currentUser = currUser;
  }

  /// Login user
  Future<UserModel?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'username': username.trim(), 'password': password.trim()},
      );

      log.i('Login successful');
       
      final savedDetalis = UserModel.fromJson(response.data);

      _currentUser = await getCurrentUser(savedDetalis.sessionToken!);
      _currentUser?.sessionToken = savedDetalis.sessionToken;

      return _currentUser;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;

      String message = 'Login failed';

      if (status == 403) {
        message = 'Unauthorized: Invalid credentials';
      } else if (data is Map && data.containsKey('error')) {
        message = data['error'];
      } else if (e.type == DioExceptionType.connectionTimeout) {
        message = 'Connection timed out. Check your internet.';
      } else if (e.type == DioExceptionType.badResponse) {
        message = 'Server error: ${e.response?.statusCode}';
      }

      log.e('Login failed: $message');
      throw AuthException(message);
    } catch (e) {
      log.e('Unexpected login error: $e');
      throw AuthException('Something went wrong. Try again later.');
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

      final savedDetalis = UserModel.fromJson(data);

      _currentUser = await getCurrentUser(savedDetalis.sessionToken!);
      _currentUser?.sessionToken = savedDetalis.sessionToken;

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
