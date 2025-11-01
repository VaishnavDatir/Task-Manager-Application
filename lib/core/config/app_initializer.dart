import '../storage/app_preferences.dart';
import '../utils/logger.dart';

class AppInitializer {
  static Future<void> init() async {
    await AppPreferences.init();

    // await Parse().initialize(
    //   ParseConfig.appId,
    //   ParseConfig.serverUrl,
    //   clientKey: ParseConfig.clientKey,
    //   autoSendSessionId: true,
    //   debug: true,
    // );

    AppLogger().i("Application initialization done");
  }
}
