sealed class Failure {
  const Failure({required this.userMessage});

  final String userMessage;
}

final class NetworkFailure extends Failure {
  const NetworkFailure({
    super.userMessage = 'Check your internet connection and try again.',
  });
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.userMessage = 'Your session has expired. Please sign in again.',
  });
}

final class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    super.userMessage = 'You do not have permission to do that.',
  });
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.userMessage = 'The requested information could not be found.',
  });
}

final class ValidationFailure extends Failure {
  const ValidationFailure({required super.userMessage});
}

final class ServerFailure extends Failure {
  const ServerFailure({
    super.userMessage = 'The service is unavailable. Please try again.',
  });
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.userMessage = 'The request took too long. Please try again.',
  });
}

final class UnknownFailure extends Failure {
  const UnknownFailure({
    super.userMessage = 'Something went wrong. Please try again.',
  });
}
