sealed class AppException implements Exception {
  const AppException({
    required this.message,
    this.statusCode,
  });

  final String message;
  final int? statusCode;
}

final class NetworkAppException extends AppException {
  const NetworkAppException({
    required super.message,
    super.statusCode,
  });
}

final class UnauthorizedAppException extends AppException {
  const UnauthorizedAppException({
    required super.message,
    super.statusCode = 401,
  });
}

final class ForbiddenAppException extends AppException {
  const ForbiddenAppException({
    required super.message,
    super.statusCode = 403,
  });
}

final class NotFoundAppException extends AppException {
  const NotFoundAppException({
    required super.message,
    super.statusCode = 404,
  });
}

final class ValidationAppException extends AppException {
  const ValidationAppException({
    required super.message,
    super.statusCode = 400,
  });
}

final class ServerAppException extends AppException {
  const ServerAppException({
    required super.message,
    super.statusCode,
  });
}

final class TimeoutAppException extends AppException {
  const TimeoutAppException({
    required super.message,
    super.statusCode,
  });
}

final class UnknownAppException extends AppException {
  const UnknownAppException({
    required super.message,
    super.statusCode,
  });
}
