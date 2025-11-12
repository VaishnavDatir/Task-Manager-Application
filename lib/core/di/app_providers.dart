import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/auth/view_model/auth_viewmodel.dart';
import '../../features/home/view_model/home_viewmodel.dart';
import '../../features/profile/view_model/profile_viewmodel.dart';
import '../../features/splash/view_model/splash_view_model.dart';
import '../../features/task/view_model/create_task_viewmodel.dart';
import '../network/api_client.dart';
import '../repositories/auth_repository.dart';
import '../repositories/task_repository.dart';
import '../storage/app_preferences.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    // Global singletons
    Provider<AppPreferences>(create: (_) => AppPreferences.instance),

    // Api client singleton (self-initializing)
    Provider<ApiClient>.value(value: ApiClient()),

    // Repository layer
    Provider<AuthRepository>(
      create: (context) => AuthRepository(context.read<ApiClient>().dio),
    ),
    Provider<TaskRepository>(
      create: (context) => TaskRepository(
        context.read<ApiClient>().dio,
        context.read<AuthRepository>(),
      ),
    ),

    // ViewModels
    ChangeNotifierProvider<SplashViewModel>(
      create: (context) => SplashViewModel(context.read<AppPreferences>()),
    ),
    ChangeNotifierProvider<ProfileViewModel>(create: (_) => ProfileViewModel()),
    ChangeNotifierProvider<AuthViewModel>(
      create: (context) => AuthViewModel(
        context.read<AuthRepository>(),
        context.read<AppPreferences>(),
      ),
    ),
    ChangeNotifierProvider<HomeViewModel>(
      create: (context) => HomeViewModel(
        context.read<TaskRepository>(),
        context.read<AuthRepository>(),
      ),
    ),
    ChangeNotifierProvider<CreateTaskViewModel>(
      create: (_) => CreateTaskViewModel(),
    ),
  ];
}
