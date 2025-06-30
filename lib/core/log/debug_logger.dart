import 'package:flutter/foundation.dart';
import 'package:repondo/core/log/app_logger.dart';

final class DebugLogger implements AppLogger {
  @override
  void info(String message) => debugPrint('INFO: $message');

  @override
  void warning(String message) => debugPrint('WARNING: $message');

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    debugPrint('ERROR: $message');
    if (error != null) debugPrint('Exception: $error');
    if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
  }
}
