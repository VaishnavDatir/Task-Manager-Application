import 'package:flutter/material.dart';

import '../../../core/models/user_model.dart';
import '../../../core/repositories/auth_repository.dart';
import '../../../core/routing/app_navigator.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/storage/app_preferences.dart';
import '../../../core/utils/logger.dart';

class SplashViewModel extends ChangeNotifier {
  final AppPreferences _prefs;
  final AuthRepository _authRepo;

  SplashViewModel(this._prefs, this._authRepo);

  /// Called once after the first frame from SplashScreen
  Future<void> initialize(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3)); // splash delay
    final UserModel? userModel = _prefs.getUserModel();
    bool isLoggedIn = userModel != null;
    log.i("isLoggedIn = $isLoggedIn");
    if (context.mounted) {
      if (isLoggedIn) {
        _authRepo.refreshCurrentUserData(userModel);
        AppNavigator.goToHome();
      } else {
        AppNavigator.goToNamed(RouteNames.welcome);
      }
    }
  }
}
