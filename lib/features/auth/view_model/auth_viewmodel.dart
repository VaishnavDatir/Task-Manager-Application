import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/user_model.dart';
import '../../../core/repositories/auth_repository.dart';
import '../../../core/routing/app_navigator.dart';
import '../../../core/storage/app_preferences.dart';

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

  Future<void> login(String email, String password) async {
    _setStatus(AuthStatus.loading);
    try {
      _user = await _authRepo.login(email, password);
      _errorMessage = null;
      _setStatus(AuthStatus.success);
      if (null != _user) {
        _prefs.saveUserSession(
          id: _user!.id,
          name: _user!.fullName,
          token: Uuid().v8(),
        );
        AppNavigator.goToHome();
      }
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _setStatus(AuthStatus.error);
    } catch (e) {
      _errorMessage = "Something went wrong. Please try again.";
      _setStatus(AuthStatus.error);
      debugPrint('Login error: $e');
    }
  }

  Future<void> signup({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setStatus(AuthStatus.loading);
    try {
      _user = await _authRepo.signup(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      );
      _errorMessage = null;
      _setStatus(AuthStatus.success);
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _setStatus(AuthStatus.error);
    } catch (e) {
      _errorMessage = "Something went wrong during signup.";
      _setStatus(AuthStatus.error);
      debugPrint('Signup error: $e');
    }
  }

  void logout() {
    _user = null;
    _setStatus(AuthStatus.idle);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }


  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }
}
