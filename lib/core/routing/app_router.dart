import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:wowtask/features/task/view/create_task_screen.dart';

import '../../features/auth/view/login_screen.dart';
import '../../features/auth/view/signup_screen.dart';
import '../../features/auth/view/welcome_screen.dart';
import '../../features/home/view/home_screen.dart';
import '../../features/splash/view/splash_screen.dart';
import '../storage/app_preferences.dart';
import '../widgets/error_screen.dart';
import 'app_routes.dart';
import 'guards/auth_guard.dart';
import 'route_names.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();


/// Global singleton router to prevent rebuild resets.
class AppRouter {
  static GoRouter? _router;

  static GoRouter createRouter(AppPreferences prefs) {
    if (_router != null) return _router!;

    final authGuard = AuthGuard(prefs);

    _router = GoRouter(
      navigatorKey: rootNavigatorKey,
      debugLogDiagnostics: kDebugMode, 
      initialLocation: AppRoutes.splash,
      routes: [
        ..._splashRoutes,
        ..._authRoutes,
        ..._homeRoutes,
        ..._taskRoutes,
        ..._errorRoutes,
      ],
      // redirect: authGuard.checkAuth,
      errorBuilder: (context, state) => const ErrorScreen(),
    );

    return _router!;
  }

  /// Splash routes
  static final List<GoRoute> _splashRoutes = [
    GoRoute(
      path: AppRoutes.splash,
      name: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),
  ];

  /// Authentication related routes
  static final List<GoRoute> _authRoutes = [
    GoRoute(
      path: AppRoutes.welcome,
      name: RouteNames.welcome,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: RouteNames.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: RouteNames.register,
      builder: (context, state) => const SignupScreen(),
    ),
  ];

  /// App routes after login (Home, Profile, TaskDetail, etc.)
  static final List<GoRoute> _homeRoutes = [
    GoRoute(
      path: AppRoutes.home,
      name: RouteNames.home,
      builder: (context, state) => const HomeScreen(),
    ),
  ];

  /// App routes after login (Home, Profile, TaskDetail, etc.)
  static final List<GoRoute> _taskRoutes = [
    GoRoute(
      path: AppRoutes.createTask,
      name: RouteNames.createTask,
      builder: (context, state) => const CreateTaskScreen(),
    ),
  ];

  /// Error and fallback routes
  static final List<GoRoute> _errorRoutes = [
    GoRoute(
      path: AppRoutes.error,
      name: RouteNames.error,
      builder: (context, state) => const ErrorScreen(),
    ),
  ];
}
