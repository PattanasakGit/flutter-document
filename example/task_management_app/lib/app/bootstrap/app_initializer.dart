import 'package:ai_first_flutter_starter/core/logging/app_logger.dart';
import 'package:flutter/foundation.dart';

final class AppInitializer {
  const AppInitializer(this._logger);

  final AppLogger _logger;

  Future<void> initialize() async {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      _logger.error(
        'Unhandled Flutter framework error',
        error: details.exception,
        stackTrace: details.stack,
      );
    };
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      _logger.error(
        'Unhandled platform error',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    };
  }
}
