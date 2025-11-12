import 'package:flutter/material.dart';

import '../../../core/routing/app_navigator.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/storage/app_preferences.dart';
import '../../../core/utils/logger.dart';

class SplashViewModel extends ChangeNotifier {
  final AppPreferences _prefs;

  SplashViewModel(this._prefs);

  /// Called once after the first frame from SplashScreen
  Future<void> initialize(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3)); // splash delay
    final isLoggedIn = _prefs.isLoggedIn;
    log.i("isLoggedIn = $isLoggedIn");

    if (context.mounted) {
      if (isLoggedIn) {
        AppNavigator.goToHome();
      } else {
        AppNavigator.goToNamed(RouteNames.welcome);
      }
    }
  }
}
