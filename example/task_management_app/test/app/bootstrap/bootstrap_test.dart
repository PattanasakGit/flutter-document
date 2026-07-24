import 'package:ai_first_flutter_starter/app/bootstrap/bootstrap.dart';
import 'package:ai_first_flutter_starter/app/config/app_config.dart';
import 'package:ai_first_flutter_starter/core/logging/app_logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('selects a no-op logger when environment logging is disabled', () {
    final logger = appLoggerFor(AppConfig.production());

    expect(logger, isA<NoOpAppLogger>());
  });

  test('selects the developer logger when environment logging is enabled', () {
    final logger = appLoggerFor(AppConfig.development());

    expect(logger, isA<DeveloperAppLogger>());
  });
}
