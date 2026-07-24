import 'package:ai_first_flutter_starter/app/config/app_config.dart';
import 'package:ai_first_flutter_starter/app/config/environment_provider.dart';
import 'package:ai_first_flutter_starter/core/logging/app_logger.dart';
import 'package:ai_first_flutter_starter/core/network/interceptors/authentication_interceptor.dart';
import 'package:ai_first_flutter_starter/core/network/interceptors/logging_interceptor.dart';
import 'package:ai_first_flutter_starter/core/network/network_provider.dart';
import 'package:ai_first_flutter_starter/core/storage/secure_storage.dart';
import 'package:ai_first_flutter_starter/core/storage/storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final class _NoOpStorage implements SecureStorage {
  @override
  Future<void> delete({required String key}) async {}

  @override
  Future<String?> read({required String key}) async => null;

  @override
  Future<void> write({
    required String key,
    required String value,
  }) async {}
}

final class _NoOpLogger implements AppLogger {
  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {}

  @override
  void info(String message) {}
}

void main() {
  ProviderContainer createContainer(AppConfig config) {
    return ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        secureStorageProvider.overrideWithValue(_NoOpStorage()),
        appLoggerProvider.overrideWithValue(_NoOpLogger()),
      ],
    );
  }

  test('configures base URL, timeouts, auth, and development logging', () {
    final container = createContainer(
      AppConfig.development(apiBaseUrl: 'https://api.example.test'),
    );
    addTearDown(container.dispose);

    final dio = container.read(dioProvider);

    expect(dio.options.baseUrl, 'https://api.example.test');
    expect(dio.options.connectTimeout, const Duration(seconds: 15));
    expect(dio.options.receiveTimeout, const Duration(seconds: 15));
    expect(
      dio.interceptors.whereType<AuthenticationInterceptor>(),
      hasLength(1),
    );
    expect(dio.interceptors.whereType<LoggingInterceptor>(), hasLength(1));
  });

  test('omits the logging interceptor in production', () {
    final container = createContainer(
      AppConfig.production(apiBaseUrl: 'https://api.example.test'),
    );
    addTearDown(container.dispose);

    final dio = container.read(dioProvider);

    expect(
      dio.interceptors.whereType<AuthenticationInterceptor>(),
      hasLength(1),
    );
    expect(dio.interceptors.whereType<LoggingInterceptor>(), isEmpty);
  });
}
