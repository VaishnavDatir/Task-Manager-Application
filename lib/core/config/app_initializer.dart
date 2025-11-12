import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../network/api_client.dart';
import '../storage/app_preferences.dart';
import '../utils/logger.dart';

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await AppPreferences.init();

    await dotenv.load(fileName: ".env");
    ApiClient().initialize();
    
    AppLogger().i("Application initialization done");
  }
}
