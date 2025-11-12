import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_keys.dart';
import '../models/user_model.dart';
import '../utils/logger.dart';

///  AppPreferences
/// A robust, type-safe wrapper around [SharedPreferences] with logging.
/// Supports saving/restoring user session and model.
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
    log.d("Saved string → [$key] = $value");
  }

  String? getString(String key) {
    _ensureInitialized();
    final value = _prefs!.getString(key);
    log.d("Fetched string ← [$key] = $value");
    return value;
  }

  Future<void> setBool(String key, bool value) async {
    _ensureInitialized();
    await _prefs!.setBool(key, value);
    log.d("Saved bool → [$key] = $value");
  }

  bool getBool(String key, {bool defaultValue = false}) {
    _ensureInitialized();
    final value = _prefs!.getBool(key) ?? defaultValue;
    log.d("Fetched bool ← [$key] = $value");
    return value;
  }

  Future<void> setInt(String key, int value) async {
    _ensureInitialized();
    await _prefs!.setInt(key, value);
    log.d("Saved int → [$key] = $value");
  }

  int? getInt(String key) {
    _ensureInitialized();
    final value = _prefs!.getInt(key);
    log.d("Fetched int ← [$key] = $value");
    return value;
  }

  Future<void> setDouble(String key, double value) async {
    _ensureInitialized();
    await _prefs!.setDouble(key, value);
    log.d("Saved double → [$key] = $value");
  }

  double? getDouble(String key) {
    _ensureInitialized();
    final value = _prefs!.getDouble(key);
    log.d("Fetched double ← [$key] = $value");
    return value;
  }

  Future<void> setStringList(String key, List<String> value) async {
    _ensureInitialized();
    await _prefs!.setStringList(key, value);
    log.d("Saved list → [$key] = $value");
  }

  List<String>? getStringList(String key) {
    _ensureInitialized();
    final value = _prefs!.getStringList(key);
    log.d("Fetched list ← [$key] = $value");
    return value;
  }

  // ==========================
  // Session Management
  // ==========================

  Future<void> saveAuthToken(String token) async {
    await setString(AppKeys.token, token);
    log.i("Auth token saved");
  }

  String? get authToken => getString(AppKeys.token);

  bool get isLoggedIn {
    _ensureInitialized();
    final bool status = getUserModel() != null;
    log.d("Checked login status → $status");
    return status;
  }

  Future<void> clearUserSession() async {
    _ensureInitialized();
    await Future.wait([
      setBool(AppKeys.isLoggedIn, false),
      _prefs!.remove(AppKeys.userData),
    ]);
    log.w("🧹 User session cleared");
  }

  // ==========================
  // User Model Persistence
  // ==========================

  Future<void> saveUserModel(UserModel user) async {
    _ensureInitialized();
    final jsonData = jsonEncode(user.toJson());
    await _prefs!.setString(AppKeys.userData, jsonData);
    log.i("👤 UserModel saved → ${user.fullName}");
  }

  UserModel? getUserModel() {
    _ensureInitialized();
    final jsonStr = _prefs!.getString(AppKeys.userData);
    if (jsonStr == null) {
      log.w("No saved user model found");
      return null;
    }
    try {
      final user = UserModel.fromJson(jsonDecode(jsonStr));
      log.d("UserModel loaded → ${user.fullName}");
      return user;
    } catch (e) {
      log.e("Failed to decode user model: $e");
      return null;
    }
  }

  // ==========================
  // Misc
  // ==========================

  Future<void> clearAll() async {
    _ensureInitialized();
    await _prefs!.clear();
    log.w("🧨 All preferences cleared");
  }
}
