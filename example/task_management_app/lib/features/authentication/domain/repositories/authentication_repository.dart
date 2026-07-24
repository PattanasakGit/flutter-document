import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/features/authentication/domain/entities/authenticated_user.dart';

abstract interface class AuthenticationRepository {
  Future<Result<AuthenticatedUser>> login({
    required String email,
    required String password,
  });

  Future<Result<void>> logout();
}
