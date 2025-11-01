import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wowtask/core/repositories/auth_repository.dart';
import 'package:wowtask/features/auth/view_model/auth_viewmodel.dart';

import '../../features/splash/view_model/splash_view_model.dart';
import '../storage/app_preferences.dart';
// Later you’ll add others like:
// import '../../features/auth/viewmodel/auth_viewmodel.dart';
// import '../../services/api_service.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    //  Global singletons
    Provider<AppPreferences>(create: (_) => AppPreferences.instance),
    Provider<AuthRepository>(create: (_) => AuthRepository()),
    // ViewModels (ChangeNotifier)
    ChangeNotifierProvider<SplashViewModel>(
      create: (context) => SplashViewModel(context.read<AppPreferences>()),
    ),
    ChangeNotifierProvider<AuthViewModel>(
      create: (context) => AuthViewModel(context.read<AuthRepository>()),
    ),
  ];
}
