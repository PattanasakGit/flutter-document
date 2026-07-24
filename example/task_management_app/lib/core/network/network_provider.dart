import 'package:ai_first_flutter_starter/app/config/environment_provider.dart';
import 'package:ai_first_flutter_starter/core/errors/error_mapper.dart';
import 'package:ai_first_flutter_starter/core/logging/app_logger.dart';
import 'package:ai_first_flutter_starter/core/network/api_client.dart';
import 'package:ai_first_flutter_starter/core/network/interceptors/authentication_interceptor.dart';
import 'package:ai_first_flutter_starter/core/network/interceptors/logging_interceptor.dart';
import 'package:ai_first_flutter_starter/core/storage/storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.add(
    AuthenticationInterceptor(ref.watch(secureStorageProvider)),
  );
  if (config.enableLogging) {
    dio.interceptors.add(
      LoggingInterceptor(ref.watch(appLoggerProvider)),
    );
  }

  ref.onDispose(() => dio.close(force: true));
  return dio;
});

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    dio: ref.watch(dioProvider),
    errorMapper: const ErrorMapper(),
  ),
);
