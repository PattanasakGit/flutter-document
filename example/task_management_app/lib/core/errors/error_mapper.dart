import 'package:ai_first_flutter_starter/core/errors/app_exception.dart';
import 'package:ai_first_flutter_starter/core/errors/failure.dart';
import 'package:dio/dio.dart';

final class ErrorMapper {
  const ErrorMapper();

  AppException mapDioException(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => TimeoutAppException(
        message: error.message ?? 'The request timed out.',
      ),
      DioExceptionType.connectionError ||
      DioExceptionType.badCertificate => NetworkAppException(
        message: error.message ?? 'A network connection failed.',
      ),
      DioExceptionType.badResponse => _mapStatusCode(
        error.response?.statusCode,
        error.message,
      ),
      DioExceptionType.cancel => const UnknownAppException(
        message: 'The request was cancelled.',
      ),
      DioExceptionType.unknown => UnknownAppException(
        message: error.message ?? 'An unknown network error occurred.',
      ),
    };
  }

  Failure mapException(Object error) {
    return switch (error) {
      NetworkAppException() => const NetworkFailure(),
      UnauthorizedAppException() => const UnauthorizedFailure(),
      ForbiddenAppException() => const ForbiddenFailure(),
      NotFoundAppException() => const NotFoundFailure(),
      ValidationAppException(:final message) => ValidationFailure(
        userMessage: message,
      ),
      ServerAppException() => const ServerFailure(),
      TimeoutAppException() => const TimeoutFailure(),
      UnknownAppException() => const UnknownFailure(),
      _ => const UnknownFailure(),
    };
  }

  AppException _mapStatusCode(int? statusCode, String? diagnosticMessage) {
    final message = diagnosticMessage ?? 'HTTP request failed.';
    return switch (statusCode) {
      400 || 422 => const ValidationAppException(
        message: 'The request was not valid.',
      ),
      401 => UnauthorizedAppException(message: message),
      403 => ForbiddenAppException(message: message),
      404 => NotFoundAppException(message: message),
      final code when code != null && code >= 500 => ServerAppException(
        message: message,
        statusCode: code,
      ),
      _ => UnknownAppException(message: message, statusCode: statusCode),
    };
  }
}
