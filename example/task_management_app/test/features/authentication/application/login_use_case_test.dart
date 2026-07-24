import 'package:ai_first_flutter_starter/core/errors/failure.dart';
import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/features/authentication/application/use_cases/login_use_case.dart';
import 'package:ai_first_flutter_starter/features/authentication/domain/entities/authenticated_user.dart';
import 'package:ai_first_flutter_starter/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_data.dart';

final class _RecordingAuthenticationRepository
    implements AuthenticationRepository {
  Result<AuthenticatedUser> loginResult = const FailureResult(
    UnknownFailure(),
  );
  String? receivedEmail;
  String? receivedPassword;
  int loginCallCount = 0;

  @override
  Future<Result<AuthenticatedUser>> login({
    required String email,
    required String password,
  }) async {
    loginCallCount += 1;
    receivedEmail = email;
    receivedPassword = password;
    return loginResult;
  }

  @override
  Future<Result<void>> logout() async => const Success(null);
}

void main() {
  late _RecordingAuthenticationRepository repository;
  late LoginUseCase useCase;

  setUp(() {
    repository = _RecordingAuthenticationRepository();
    useCase = LoginUseCase(repository);
  });

  test('rejects a malformed email before calling the repository', () async {
    final result = await useCase(
      email: 'invalid',
      password: TestData.password,
    );

    expect(result, isA<FailureResult<AuthenticatedUser>>());
    expect(repository.loginCallCount, 0);
  });

  test('rejects a short password before calling the repository', () async {
    final result = await useCase(
      email: TestData.email,
      password: 'short',
    );

    expect(result, isA<FailureResult<AuthenticatedUser>>());
    expect(repository.loginCallCount, 0);
  });

  test('delegates valid credentials to the repository', () async {
    const user = AuthenticatedUser(
      id: TestData.userId,
      email: TestData.email,
      displayName: TestData.displayName,
    );
    repository.loginResult = const Success(user);

    final result = await useCase(
      email: TestData.email,
      password: TestData.password,
    );

    expect((result as Success<AuthenticatedUser>).data, user);
    expect(repository.receivedEmail, TestData.email);
    expect(repository.receivedPassword, TestData.password);
  });
}
