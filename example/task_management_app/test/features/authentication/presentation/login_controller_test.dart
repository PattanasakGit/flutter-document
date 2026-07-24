import 'dart:async';

import 'package:ai_first_flutter_starter/core/errors/failure.dart';
import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/features/authentication/authentication_providers.dart';
import 'package:ai_first_flutter_starter/features/authentication/domain/entities/authenticated_user.dart';
import 'package:ai_first_flutter_starter/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:ai_first_flutter_starter/features/authentication/presentation/controllers/login_controller.dart';
import 'package:ai_first_flutter_starter/features/authentication/presentation/states/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_data.dart';

final class _ControllableAuthenticationRepository
    implements AuthenticationRepository {
  Completer<Result<AuthenticatedUser>>? loginCompleter;
  Result<AuthenticatedUser>? immediateLoginResult;
  Result<void> logoutResult = const Success(null);
  int loginCallCount = 0;
  int logoutCallCount = 0;

  @override
  Future<Result<AuthenticatedUser>> login({
    required String email,
    required String password,
  }) {
    loginCallCount += 1;
    final immediateResult = immediateLoginResult;
    if (immediateResult != null) {
      return Future.value(immediateResult);
    }
    return loginCompleter!.future;
  }

  @override
  Future<Result<void>> logout() async {
    logoutCallCount += 1;
    return logoutResult;
  }
}

void main() {
  const user = AuthenticatedUser(
    id: TestData.userId,
    email: TestData.email,
    displayName: TestData.displayName,
  );

  late _ControllableAuthenticationRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _ControllableAuthenticationRepository();
    container = ProviderContainer(
      overrides: [
        authenticationRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('starts in the idle state', () {
    final state = container.read(loginControllerProvider);

    expect(state.status, LoginStatus.idle);
    expect(state.user, isNull);
  });

  test('emits loading then success for valid credentials', () async {
    repository.loginCompleter = Completer<Result<AuthenticatedUser>>();
    final controller = container.read(loginControllerProvider.notifier);

    final future = controller.login(
      email: TestData.email,
      password: TestData.password,
    );

    expect(container.read(loginControllerProvider).status, LoginStatus.loading);

    repository.loginCompleter!.complete(const Success(user));
    await future;

    final state = container.read(loginControllerProvider);
    expect(state.status, LoginStatus.success);
    expect(state.user, user);
  });

  test('exposes a user-safe failure message', () async {
    repository.immediateLoginResult = const FailureResult(
      UnauthorizedFailure(),
    );

    await container
        .read(loginControllerProvider.notifier)
        .login(
          email: TestData.email,
          password: TestData.password,
        );

    final state = container.read(loginControllerProvider);
    expect(state.status, LoginStatus.failure);
    expect(state.errorMessage, contains('sign in'));
  });

  test('does not call the repository when validation fails', () async {
    await container
        .read(loginControllerProvider.notifier)
        .login(
          email: 'invalid',
          password: TestData.password,
        );

    final state = container.read(loginControllerProvider);
    expect(repository.loginCallCount, 0);
    expect(state.status, LoginStatus.failure);
    expect(state.errorMessage, 'Enter a valid email address.');
  });

  test('clears the authenticated session on logout', () async {
    repository.immediateLoginResult = const Success(user);
    final controller = container.read(loginControllerProvider.notifier);
    await controller.login(
      email: TestData.email,
      password: TestData.password,
    );

    await controller.logout();

    expect(repository.logoutCallCount, 1);
    expect(container.read(loginControllerProvider).user, isNull);
    expect(container.read(loginControllerProvider).status, LoginStatus.idle);
  });
}
