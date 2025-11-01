import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// App-wide logger utility
/// Supports different log levels, tagging, and automatic disable in release builds.
class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;

  late Logger _logger;

  AppLogger._internal() {
    _logger = Logger(
      printer: SimplePrinter(printTime: true, colors: false),
      filter: _ReleaseFilter(), // Custom filter to disable logs in release mode
    );
  }

  /// Log informational messages
  void i(String message, {String? tag}) {
    _logger.i(_format(message, tag));
  }

  /// Log warning messages
  void w(String message, {String? tag}) {
    _logger.w(_format(message, tag));
  }

  /// Log error messages (with optional exception or stacktrace)
  void e(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    _logger.e(_format(message, tag), error: error, stackTrace: stackTrace);
  }

  /// Log verbose/debug messages
  void d(String message, {String? tag}) {
    _logger.d(_format(message, tag));
  }

  /// Log critical/fatal messages
  void f(String message, {String? tag}) {
    _logger.f(_format(message, tag));
  }

  String _format(String message, String? tag) {
    return tag != null ? "[$tag] $message" : message;
  }
}

/// Custom log filter: disables logs in release builds
class _ReleaseFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => kDebugMode;
}

/// Global instance for easy access
final log = AppLogger();
