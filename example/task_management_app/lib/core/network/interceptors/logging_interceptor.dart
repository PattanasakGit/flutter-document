import 'package:ai_first_flutter_starter/core/logging/app_logger.dart';
import 'package:dio/dio.dart';

final class LoggingInterceptor extends Interceptor {
  LoggingInterceptor(this._logger);

  final AppLogger _logger;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    _logger.info('HTTP ${options.method} ${options.path}');
    handler.next(options);
  }
}
