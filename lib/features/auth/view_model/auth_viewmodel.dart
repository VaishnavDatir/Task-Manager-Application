import 'package:flutter/foundation.dart';

import '../../../core/models/user_model.dart';
import '../../../core/repositories/auth_repository.dart';
import '../../../core/routing/app_navigator.dart';
import '../../../core/storage/app_preferences.dart';
import '../../../core/utils/logger.dart';

enum AuthStatus { idle, loading, success, error }

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepo;
  final AppPreferences _prefs;

  AuthViewModel(this._authRepo, this._prefs);

  AuthStatus _status = AuthStatus.idle;
  UserModel? _user;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _status == AuthStatus.loading;
  bool get isLoggedIn => _user != null;

  /// Load profile from logged-in user
  Future<void> loadProfile() async {
    _setStatus(AuthStatus.loading);
    notifyListeners();

    // Simply read user stored in AuthRepository
    _user = _authRepo.currentUser;

    _setStatus(AuthStatus.success);
    notifyListeners();
  }

  // LOGIN
  Future<void> login(String username, String password) async {
    _setStatus(AuthStatus.loading);

    try {
      final user = await _authRepo.login(username, password);
      if (user == null) {
        throw AuthException('User not found.');
      }

      _user = user;
      _errorMessage = null;
      _setStatus(AuthStatus.success);

      await _prefs.saveUserModel(user);
      log.i('Logged in as ${user.fullName}');
      AppNavigator.goToHome();
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _setStatus(AuthStatus.error);
      log.w('AuthException: ${e.message}');
    } catch (e, st) {
      _errorMessage = 'Something went wrong. Please try again.';
      _setStatus(AuthStatus.error);
      log.e('Unexpected login error', error: e, stackTrace: st);
    }
  }

  //  SIGNUP
  Future<void> signup({
    required String username,
    required String phone,
    required String password,
    required String fullName,
    String? email,
  }) async {
    _setStatus(AuthStatus.loading);
    try {
      final user = await _authRepo.signup(
        username: username,
        password: password,
        fullName: fullName,
        phone: phone,
        email: email ?? username
      );

      _user = user;
      _errorMessage = null;
      _setStatus(AuthStatus.success);

      await _prefs.saveUserModel(user!);
      log.i('Signup successful: ${user.email}');
      AppNavigator.goToLogin();
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _setStatus(AuthStatus.error);
      log.w('Signup AuthException: ${e.message}');
    } catch (e, st) {
      _errorMessage = 'Something went wrong during signup.';
      _setStatus(AuthStatus.error);
      log.e('Unexpected signup error', error: e, stackTrace: st);
    }
  }

  //  LOGOUT
  Future<void> logout() async {
    try {
      await _authRepo.logout();
      await _prefs.clearUserSession();

      _user = null;
      _setStatus(AuthStatus.idle);

      log.i('User logged out');
      AppNavigator.goToLogin();
    } catch (e, st) {
      log.e('Logout failed', error: e, stackTrace: st);
    }
  }

  // AUTO LOGIN
  Future<void> tryAutoLogin() async {
    try {
      final cachedUser = _prefs.getUserModel();

      if (cachedUser != null) {
        _user = cachedUser;
        _setStatus(AuthStatus.success);

        log.i('🔄 Auto-login restored for ${cachedUser.fullName}');
      } else {
        log.i('ℹ️ No cached session found');
      }
    } catch (e, st) {
      log.e('❌ Auto-login failed', error: e, stackTrace: st);
    }
  }

  //  UTILITIES
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }
}
