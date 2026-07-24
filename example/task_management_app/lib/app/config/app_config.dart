import 'package:ai_first_flutter_starter/app/config/app_environment.dart';

final class AppConfig {
  const AppConfig({
    required this.environment,
    required this.appName,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.enableDebugBanner,
    required this.environmentLabel,
  });

  factory AppConfig.development({
    String apiBaseUrl = const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://development.example.invalid',
    ),
  }) {
    return AppConfig(
      environment: AppEnvironment.development,
      appName: 'AI Starter Dev',
      apiBaseUrl: apiBaseUrl,
      enableLogging: true,
      enableDebugBanner: true,
      environmentLabel: 'DEVELOPMENT',
    );
  }

  factory AppConfig.staging({
    String apiBaseUrl = const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://staging.example.invalid',
    ),
  }) {
    return AppConfig(
      environment: AppEnvironment.staging,
      appName: 'AI Starter Staging',
      apiBaseUrl: apiBaseUrl,
      enableLogging: false,
      enableDebugBanner: false,
      environmentLabel: 'STAGING',
    );
  }

  factory AppConfig.production({
    String apiBaseUrl = const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://production.example.invalid',
    ),
  }) {
    return AppConfig(
      environment: AppEnvironment.production,
      appName: 'AI Starter',
      apiBaseUrl: apiBaseUrl,
      enableLogging: false,
      enableDebugBanner: false,
      environmentLabel: 'PRODUCTION',
    );
  }

  final AppEnvironment environment;
  final String appName;
  final String apiBaseUrl;
  final bool enableLogging;
  final bool enableDebugBanner;
  final String environmentLabel;
}
