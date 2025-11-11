import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/auth/view_model/auth_viewmodel.dart';
import '../../features/profile/view_model/profile_viewmodel.dart';
import '../../features/splash/view_model/splash_view_model.dart';
import '../repositories/auth_repository.dart';
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
    ChangeNotifierProvider<ProfileViewModel>(
      create: (context) => ProfileViewModel(),
    ),
    
    ChangeNotifierProvider<AuthViewModel>(
      create: (context) => AuthViewModel(
        context.read<AuthRepository>(),
        context.read<AppPreferences>(),
      ),
    ),
  ];
}
