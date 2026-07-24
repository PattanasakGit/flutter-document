import 'package:ai_first_flutter_starter/core/errors/failure.dart';
import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/features/authentication/domain/entities/authenticated_user.dart';
import 'package:ai_first_flutter_starter/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:ai_first_flutter_starter/shared/validators/credential_validators.dart';

final class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthenticationRepository _repository;

  Future<Result<AuthenticatedUser>> call({
    required String email,
    required String password,
  }) {
    final emailError = CredentialValidators.email(email);
    if (emailError != null) {
      return Future.value(
        FailureResult(
          ValidationFailure(userMessage: emailError),
        ),
      );
    }

    final passwordError = CredentialValidators.password(password);
    if (passwordError != null) {
      return Future.value(
        FailureResult(
          ValidationFailure(userMessage: passwordError),
        ),
      );
    }

    return _repository.login(
      email: email.trim(),
      password: password,
    );
  }
}
