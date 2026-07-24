import 'package:ai_first_flutter_starter/app/config/app_config.dart';
import 'package:ai_first_flutter_starter/app/config/app_environment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('development enables diagnostics and a debug banner', () {
    final config = AppConfig.development(
      apiBaseUrl: 'https://development.example.test',
    );

    expect(config.environment, AppEnvironment.development);
    expect(config.appName, 'AI Starter Dev');
    expect(config.environmentLabel, 'DEVELOPMENT');
    expect(config.enableLogging, isTrue);
    expect(config.enableDebugBanner, isTrue);
    expect(config.apiBaseUrl, 'https://development.example.test');
  });

  test('production disables diagnostics and the debug banner', () {
    final config = AppConfig.production(
      apiBaseUrl: 'https://production.example.test',
    );

    expect(config.environment, AppEnvironment.production);
    expect(config.appName, 'AI Starter');
    expect(config.environmentLabel, 'PRODUCTION');
    expect(config.enableLogging, isFalse);
    expect(config.enableDebugBanner, isFalse);
  });

  test('staging disables diagnostic logging and the debug banner', () {
    final config = AppConfig.staging(
      apiBaseUrl: 'https://staging.example.test',
    );

    expect(config.environment, AppEnvironment.staging);
    expect(config.enableLogging, isFalse);
    expect(config.enableDebugBanner, isFalse);
  });
}
