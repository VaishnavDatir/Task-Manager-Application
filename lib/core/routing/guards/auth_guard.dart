import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../storage/app_preferences.dart';
import '../app_routes.dart';

/// Handles redirection based on authentication status
class AuthGuard {
  final AppPreferences prefs;

  AuthGuard(this.prefs);

  Future<String?> checkAuth(BuildContext context, GoRouterState state) async {
    final isLoggedIn = prefs.isLoggedIn;

    // Allow splash to load without redirect
    if (state.matchedLocation == AppRoutes.splash) return null;

    final isAuthRoute =
        state.matchedLocation.startsWith(AppRoutes.welcome) ||
        state.matchedLocation.startsWith(AppRoutes.login) ||
        state.matchedLocation.startsWith(AppRoutes.register);

    if (!isLoggedIn && !isAuthRoute) {
      // User not logged in → redirect to welcome
      return AppRoutes.welcome;
    }

    if (isLoggedIn && isAuthRoute) {
      // User already logged in → redirect to home/dashboard
      return AppRoutes.home;
    }

    return null; // ✅ No redirect needed
  }
}
