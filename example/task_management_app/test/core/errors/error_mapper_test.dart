import 'package:ai_first_flutter_starter/core/errors/app_exception.dart';
import 'package:ai_first_flutter_starter/core/errors/error_mapper.dart';
import 'package:ai_first_flutter_starter/core/errors/failure.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const mapper = ErrorMapper();

  group('ErrorMapper.mapDioException', () {
    test('maps connection timeout to TimeoutAppException', () {
      final error = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.connectionTimeout,
      );

      final exception = mapper.mapDioException(error);

      expect(exception, isA<TimeoutAppException>());
    });

    test('maps transform timeout to TimeoutAppException', () {
      final error = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.transformTimeout,
      );

      final exception = mapper.mapDioException(error);

      expect(exception, isA<TimeoutAppException>());
    });

    test('maps 401 response to UnauthorizedAppException', () {
      final request = RequestOptions();
      final error = DioException.badResponse(
        statusCode: 401,
        requestOptions: request,
        response: Response<void>(requestOptions: request, statusCode: 401),
      );

      final exception = mapper.mapDioException(error);

      expect(exception, isA<UnauthorizedAppException>());
    });

    test('maps connection error to NetworkAppException', () {
      final error = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.connectionError,
      );

      final exception = mapper.mapDioException(error);

      expect(exception, isA<NetworkAppException>());
    });
  });

  group('ErrorMapper.mapException', () {
    test('keeps diagnostic timeout detail out of the user message', () {
      const exception = TimeoutAppException(
        message: 'socket timed out after 30000ms',
      );

      final failure = mapper.mapException(exception);

      expect(failure, isA<TimeoutFailure>());
      expect(failure.userMessage, isNot(contains('30000')));
    });

    test('maps validation message to a ValidationFailure', () {
      const exception = ValidationAppException(
        message: 'Password must have at least 8 characters.',
      );

      final failure = mapper.mapException(exception);

      expect(failure, isA<ValidationFailure>());
      expect(
        failure.userMessage,
        'Password must have at least 8 characters.',
      );
    });

    test('maps unknown objects to UnknownFailure', () {
      final failure = mapper.mapException(StateError('unexpected'));

      expect(failure, isA<UnknownFailure>());
    });
  });
}
