import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class AppLogger {
  void info(String message);

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  });
}

final class DeveloperAppLogger implements AppLogger {
  const DeveloperAppLogger();

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: 'ai_first_flutter_starter',
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }

  @override
  void info(String message) {
    developer.log(message, name: 'ai_first_flutter_starter');
  }
}

final class NoOpAppLogger implements AppLogger {
  const NoOpAppLogger();

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {}

  @override
  void info(String message) {}
}

final appLoggerProvider = Provider<AppLogger>(
  (ref) => const DeveloperAppLogger(),
);
