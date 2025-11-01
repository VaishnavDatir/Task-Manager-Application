import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wowtask/core/routing/app_routes.dart';

/// A clean, centralized navigator for type-safe routing.
/// Keeps ViewModels & Widgets free from context.go() repetition.
class AppNavigator {
  AppNavigator._();
  static void goTo(BuildContext context, String appRoute) {
    context.go(appRoute);
  }

  static void goToNamed(BuildContext context, String routeName) {
    context.goNamed(routeName);
  }

  static void pushToNamed(BuildContext context, String routeName) {
    context.pushNamed(routeName);
  }

  /// Splash → Home
  static void goToHome(BuildContext context) {
    context.go(AppRoutes.home);
  }

  /// Splash → Login
  static void goToLogin(BuildContext context) {
    context.go(AppRoutes.login);
  }

  /// Any page → Profile
  static void goToProfile(BuildContext context) {
    context.push(AppRoutes.profile);
  }

  /// Navigate to specific Task Details
  static void goToTaskDetail(BuildContext context, String id) {
    context.push(AppRoutes.taskDetail.replaceAll(':id', id));
  }

  /// Back navigation
  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }

  /// Show generic error page
  static void goToError(BuildContext context) {
    context.go(AppRoutes.error);
  }
}
