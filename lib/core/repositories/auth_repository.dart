import 'dart:async';

import '../models/user_model.dart';

/// AuthRepository
/// Handles all authentication-related API calls or logic.
/// Currently simulates mock API behavior — can be replaced later with real API integration.
class AuthRepository {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  /// Simulated login method
  Future<UserModel?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2)); // simulate network delay

    if (email == 'test@demo.com' && password == '1234') {
      _currentUser = UserModel(
        id: '1',
        fullName: 'Vaishnav Datir',
        email: email,
        phone: '+91 9876543210',
        profileImage: 'https://i.pravatar.cc/150?img=3',
        role: 'student',
        createdAt: DateTime(2024, 5, 10),
        updatedAt: DateTime.now(),
        isActive: true,
      );
      return _currentUser;
    } else {
      throw AuthException(
        'Invalid credentials. Please check your email or password.',
      );
    }
  }

  /// Simulated signup method
  Future<UserModel> signup({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      email: email,
      phone: phone,
      profileImage: null,
      role: 'student',
      createdAt: DateTime.now(),
      updatedAt: null,
      isActive: true,
    );
  }

  /// Simulated logout
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Would clear session/token if using SharedPreferences or secure storage
  }
}

/// Custom exception for authentication-related errors
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}
