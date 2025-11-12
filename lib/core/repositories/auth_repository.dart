import 'dart:async';

import 'package:dio/dio.dart';

import '../models/user_model.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../utils/logger.dart';

class AuthRepository {
  final Dio _dio = ApiClient().dio;
  UserModel? _currentUser;
  String? _sessionToken;

  UserModel? get currentUser => _currentUser;
  String? get sessionToken => _sessionToken;

  /// 🔐 Login user
  Future<UserModel?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'username': username, 'password': password},
      );

      AppLogger().i('✅ Login successful');
      AppLogger().d(response.data);

      final data = response.data;

      _currentUser = UserModel.fromJson(data);
      _sessionToken = data['sessionToken'] ?? data['token'];

      return _currentUser;
    } on DioException catch (e) {
      final message = e.response?.data['error'] ?? 'Login failed';
      AppLogger().e('❌ Login failed: $message');
      throw AuthException(message);
    }
  }

  /// 📝 Signup user
  Future<UserModel?> signup({
    required String username,
    required String password,
    required String fullName,
    String? phone,
    String? email,
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

      AppLogger().i('✅ Signup successful');
      AppLogger().d(response.data);

      final data = response.data;

      _currentUser = UserModel.fromJson(data);
      _sessionToken = data['sessionToken'] ?? data['token'];

      return _currentUser;
    } on DioException catch (e) {
      final message = e.response?.data['error'] ?? 'Signup failed';
      AppLogger().e('❌ Signup failed: $message');
      throw AuthException(message);
    }
  }

  /// 👤 Fetch current user (using session)
  Future<UserModel?> getCurrentUser(String sessionToken) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.me,
        options: Options(headers: {'X-Parse-Session-Token': sessionToken}),
      );

      AppLogger().i('✅ Current user fetched');
      _currentUser = UserModel.fromJson(response.data);
      return _currentUser;
    } on DioException catch (e) {
      final message = e.response?.data['error'] ?? 'Fetch user failed';
      AppLogger().e('❌ Fetch current user failed: $message');
      throw AuthException(message);
    }
  }

  /// 🚪 Logout
  Future<void> logout() async {
    try {
      if (_sessionToken != null) {
        await _dio.post(
          ApiEndpoints.logout,
          options: Options(headers: {'X-Parse-Session-Token': _sessionToken}),
        );
      }

      AppLogger().i('🚪 Logout successful');
    } catch (e) {
      AppLogger().w('⚠️ Logout API call failed (ignoring): $e');
    } finally {
      _currentUser = null;
      _sessionToken = null;
    }
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}
