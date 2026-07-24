import 'package:ai_first_flutter_starter/app/bootstrap/app_initializer.dart';
import 'package:ai_first_flutter_starter/core/logging/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

final class _RecordingLogger implements AppLogger {
  Object? recordedError;
  StackTrace? recordedStackTrace;

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    recordedError = error;
    recordedStackTrace = stackTrace;
  }

  @override
  void info(String message) {}
}

void main() {
  testWidgets('logs platform errors without claiming recovery', (tester) async {
    final previousFlutterHandler = FlutterError.onError;
    final previousPlatformHandler = PlatformDispatcher.instance.onError;
    final logger = _RecordingLogger();
    addTearDown(() {
      FlutterError.onError = previousFlutterHandler;
      PlatformDispatcher.instance.onError = previousPlatformHandler;
    });

    await AppInitializer(logger).initialize();
    final error = StateError('platform failure');
    final stackTrace = StackTrace.current;

    final wasHandled = PlatformDispatcher.instance.onError!(
      error,
      stackTrace,
    );

    expect(wasHandled, isFalse);
    expect(logger.recordedError, same(error));
    expect(logger.recordedStackTrace, same(stackTrace));
  });
}
