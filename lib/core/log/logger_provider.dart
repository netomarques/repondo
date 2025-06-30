import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/core/log/app_logger.dart';
import 'package:repondo/core/log/crashlytics_logger.dart';
import 'package:repondo/core/log/debug_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logger_provider.g.dart';

@riverpod
AppLogger logger(Ref ref) {
  return kReleaseMode ? CrashlyticsLogger() : DebugLogger();
}
