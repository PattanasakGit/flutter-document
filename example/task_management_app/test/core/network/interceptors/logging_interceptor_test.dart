import 'package:ai_first_flutter_starter/core/logging/app_logger.dart';
import 'package:ai_first_flutter_starter/core/network/interceptors/logging_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAppLogger extends Mock implements AppLogger {}

class _MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

void main() {
  late AppLogger logger;
  late RequestInterceptorHandler handler;
  late LoggingInterceptor interceptor;

  setUpAll(() {
    registerFallbackValue(RequestOptions());
  });

  setUp(() {
    logger = _MockAppLogger();
    handler = _MockRequestInterceptorHandler();
    interceptor = LoggingInterceptor(logger);
  });

  test('logs method and path then continues the request', () {
    final options = RequestOptions(
      path: '/sessions',
      method: 'POST',
      data: <String, Object?>{'password': 'secret'},
    );

    interceptor.onRequest(options, handler);

    verify(() => logger.info('HTTP POST /sessions')).called(1);
    verify(() => handler.next(options)).called(1);
    verifyNever(() => logger.info(any(that: contains('secret'))));
  });
}
