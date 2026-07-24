import 'package:ai_first_flutter_starter/features/authentication/domain/entities/authenticated_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

enum LoginStatus {
  idle,
  loading,
  success,
  failure,
}

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default(LoginStatus.idle) LoginStatus status,
    AuthenticatedUser? user,
    String? errorMessage,
  }) = _LoginState;
}
