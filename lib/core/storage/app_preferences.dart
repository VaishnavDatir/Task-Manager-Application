import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_keys.dart';

/// 🌟 AppPreferences
/// A robust, type-safe wrapper around [SharedPreferences].
///
/// Built for MVVM or Clean Architecture with scalability in mind.
///
/// Example usage:
/// ```dart
/// await AppPreferences.instance.saveAuthToken('abcd1234');
/// final token = AppPreferences.instance.authToken;
/// await AppPreferences.instance.clearUserSession();
/// ```
class AppPreferences {
  static AppPreferences? _instance;
  static SharedPreferences? _prefs;

  AppPreferences._internal();

  /// Singleton instance
  static AppPreferences get instance {
    _instance ??= AppPreferences._internal();
    return _instance!;
  }

  /// Must be called before any usage (e.g. inside main())
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Ensures preferences are initialized
  void _ensureInitialized() {
    if (_prefs == null) {
      throw Exception(
        'AppPreferences not initialized! Call AppPreferences.init() before use.',
      );
    }
  }

  // ==========================
  // Generic Getters & Setters
  // ==========================

  Future<void> setString(String key, String value) async {
    _ensureInitialized();
    await _prefs!.setString(key, value);
  }

  String? getString(String key) {
    _ensureInitialized();
    return _prefs!.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    _ensureInitialized();
    await _prefs!.setBool(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    _ensureInitialized();
    return _prefs!.getBool(key) ?? defaultValue;
  }

  Future<void> setInt(String key, int value) async {
    _ensureInitialized();
    await _prefs!.setInt(key, value);
  }

  int? getInt(String key) {
    _ensureInitialized();
    return _prefs!.getInt(key);
  }

  Future<void> setDouble(String key, double value) async {
    _ensureInitialized();
    await _prefs!.setDouble(key, value);
  }

  double? getDouble(String key) {
    _ensureInitialized();
    return _prefs!.getDouble(key);
  }

  Future<void> setStringList(String key, List<String> value) async {
    _ensureInitialized();
    await _prefs!.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    _ensureInitialized();
    return _prefs!.getStringList(key);
  }

  // ==========================
  // Common Application Methods
  // ==========================

  Future<void> saveAuthToken(String token) async =>
      setString(AppKeys.token, token);

  String? get authToken => getString(AppKeys.token);

  Future<void> saveUserSession({
    required String id,
    required String name,
    required String token,
  }) async {
    _ensureInitialized();
    await Future.wait([
      setString(AppKeys.userId, id),
      setString(AppKeys.userName, name),
      setString(AppKeys.token, token),
      setBool(AppKeys.isLoggedIn, true),
    ]);
  }

  Future<void> clearUserSession() async {
    _ensureInitialized();
    await Future.wait([
      _prefs!.remove(AppKeys.userId),
      _prefs!.remove(AppKeys.userName),
      _prefs!.remove(AppKeys.token),
      setBool(AppKeys.isLoggedIn, false),
    ]);
  }

  bool get isLoggedIn {
    _ensureInitialized();
    return getBool(AppKeys.isLoggedIn);
  }

  Future<void> clearAll() async {
    _ensureInitialized();
    await _prefs!.clear();
  }
}
