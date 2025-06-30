import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:repondo/core/log/app_logger.dart';

final class CrashlyticsLogger implements AppLogger {
  final _crashlytics = FirebaseCrashlytics.instance;

  @override
  void info(String message) => _crashlytics.log('INFO: $message');

  @override
  void warning(String message) => _crashlytics.log('WARNING: $message');

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _crashlytics.log('ERROR: $message');
    _crashlytics.recordError(
      error ?? message,
      stackTrace ?? StackTrace.current,
    );
  }
}
