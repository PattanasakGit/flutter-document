import 'package:ai_first_flutter_starter/features/authentication/data/dtos/login_response_dto.dart';
import 'package:ai_first_flutter_starter/features/authentication/domain/entities/authenticated_user.dart';

extension AuthenticationMapper on LoginResponseDto {
  AuthenticatedUser toEntity() {
    return AuthenticatedUser(
      id: id,
      email: email,
      displayName: displayName,
    );
  }
}
