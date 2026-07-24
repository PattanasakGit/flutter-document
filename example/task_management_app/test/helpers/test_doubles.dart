import 'dart:async';

import 'package:ai_first_flutter_starter/core/errors/failure.dart';
import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/features/authentication/domain/entities/authenticated_user.dart';
import 'package:ai_first_flutter_starter/features/authentication/domain/repositories/authentication_repository.dart';

final class FakeAuthenticationRepository implements AuthenticationRepository {
  Result<AuthenticatedUser> loginResult = const FailureResult(
    UnauthorizedFailure(),
  );
  Result<void> logoutResult = const Success(null);
  Completer<Result<AuthenticatedUser>>? loginCompleter;
  Completer<Result<void>>? logoutCompleter;
  int loginCallCount = 0;
  int logoutCallCount = 0;

  @override
  Future<Result<AuthenticatedUser>> login({
    required String email,
    required String password,
  }) {
    loginCallCount += 1;
    final completer = loginCompleter;
    if (completer != null) {
      return completer.future;
    }
    return Future.value(loginResult);
  }

  @override
  Future<Result<void>> logout() {
    logoutCallCount += 1;
    final completer = logoutCompleter;
    if (completer != null) {
      return completer.future;
    }
    return Future.value(logoutResult);
  }
}
