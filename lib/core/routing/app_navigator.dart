import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';
import 'route_names.dart';

class AppNavigator {
  AppNavigator._();

  /// Safely get the GoRouter instance
  static GoRouter get _router {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) {
      throw FlutterError('Router context not ready');
    }
    return GoRouter.of(ctx);
  }

  // ---------------- GoRouter-based navigation ----------------

  /// Go to a route by *path* (e.g. AppRoutes.home)
  static void goTo(String route) => _router.go(route);

  /// Go to a route by *name* (e.g. RouteNames.home)
  static void goToNamed(
    String name, {
    Map<String, String>? params,
    Object? extra,
  }) {
    _router.goNamed(name, pathParameters: params ?? const {}, extra: extra);
  }

  /// Push a new route by *name* (adds to stack)
  static Future<T?> pushToNamed<T>(
    String name, {
    Map<String, String>? params,
    Object? extra,
  }) async {
    return await _router.pushNamed<T>(
      name,
      pathParameters: params ?? const {},
      extra: extra,
    );
  }

  /// Replace current route
  static void replaceWithNamed(
    String name, {
    Map<String, String>? params,
    Object? extra,
  }) {
    _router.replaceNamed(
      name,
      pathParameters: params ?? const {},
      extra: extra,
    );
  }

  /// Go back if possible
  static void goBack() {
    if (_router.canPop()) _router.pop();
  }

  // ---------------- Native Navigator-based navigation ----------------

  /// Push a Flutter [Widget] manually (useful when you need return values)
  static Future<T?> pushScreen<T>(Widget page) async {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) {
      throw FlutterError('Navigator context not ready');
    }
    return Navigator.of(ctx).push<T>(MaterialPageRoute(builder: (_) => page));
  }

  /// Pop a value back from native navigation
  static void pop<T extends Object?>([T? result]) {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) return;
    Navigator.of(ctx).pop(result);
  }

  // ---------------- Common helpers ----------------

  static void goToHome() => goToNamed(RouteNames.home);
  static void goToLogin() => goToNamed(RouteNames.login);
  static void goToTaskDetail(String id) =>
      goToNamed(RouteNames.taskDetail, params: {'id': id});

  

}
