import 'package:go_router/go_router.dart';

import 'app_router.dart'; // to access rootNavigatorKey
import 'app_routes.dart';

class AppNavigator {
  AppNavigator._();

  static GoRouter get _router => GoRouter.of(rootNavigatorKey.currentContext!);

  static void goTo(String route) => _router.go(route);
  static void goToNamed(String name) => _router.goNamed(name);
  static void pushToNamed(String name) => _router.pushNamed(name);
  static void goToHome() => goTo(AppRoutes.home);
  static void goToLogin() => goTo(AppRoutes.login);
  static void goToProfile() => _router.push(AppRoutes.profile);
  static void goToTaskDetail(String id) =>
      _router.push(AppRoutes.taskDetail.replaceAll(':id', id));
  static void goBack() => _router.pop();
  static void goToError() => goTo(AppRoutes.error);
}
