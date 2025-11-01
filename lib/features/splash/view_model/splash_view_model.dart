import 'package:flutter/material.dart';
import 'package:wowtask/core/routing/route_names.dart';
import 'package:wowtask/core/utils/logger.dart';

import '../../../core/routing/app_navigator.dart';
import '../../../core/storage/app_preferences.dart';

class SplashViewModel extends ChangeNotifier {
  final AppPreferences _prefs;

  SplashViewModel(this._prefs);

  /// Called once after the first frame from SplashScreen
  Future<void> initialize(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 4)); // splash delay
    final isLoggedIn = _prefs.isLoggedIn;
    AppLogger().i("isLoggedIn = $isLoggedIn");

    if (context.mounted) {
      if (isLoggedIn) {
        AppNavigator.goToHome(context);
      } else {
        AppNavigator.goToNamed(context, RouteNames.welcome);
      }
    }
  }
}
