import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/features/authentication/authentication_providers.dart';
import 'package:ai_first_flutter_starter/features/authentication/domain/entities/authenticated_user.dart';
import 'package:ai_first_flutter_starter/features/authentication/presentation/states/login_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_controller.g.dart';

@Riverpod(keepAlive: true)
class LoginController extends _$LoginController {
  @override
  LoginState build() => const LoginState();

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      status: LoginStatus.loading,
      errorMessage: null,
    );

    final result = await ref
        .read(loginUseCaseProvider)
        .call(
          email: email,
          password: password,
        );

    state = switch (result) {
      Success<AuthenticatedUser>(:final data) => LoginState(
        status: LoginStatus.success,
        user: data,
      ),
      FailureResult<AuthenticatedUser>(:final failure) => LoginState(
        status: LoginStatus.failure,
        errorMessage: failure.userMessage,
      ),
    };
  }

  Future<void> logout() async {
    state = state.copyWith(
      status: LoginStatus.loading,
      errorMessage: null,
    );
    final result = await ref.read(authenticationRepositoryProvider).logout();

    state = switch (result) {
      Success<void>() => const LoginState(),
      FailureResult<void>(:final failure) => state.copyWith(
        status: LoginStatus.failure,
        errorMessage: failure.userMessage,
      ),
    };
  }
}

@riverpod
AuthenticatedUser? authenticationSession(Ref ref) {
  return ref.watch(loginControllerProvider).user;
}
