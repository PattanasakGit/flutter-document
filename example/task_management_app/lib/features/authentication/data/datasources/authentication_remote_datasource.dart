import 'package:ai_first_flutter_starter/core/errors/app_exception.dart';
import 'package:ai_first_flutter_starter/features/authentication/data/dtos/login_request_dto.dart';
import 'package:ai_first_flutter_starter/features/authentication/data/dtos/login_response_dto.dart';

// This interface is intentionally narrow so HTTP and fake transports remain
// replaceable without leaking transport details into the repository.
// ignore: one_member_abstracts
abstract interface class AuthenticationRemoteDatasource {
  Future<LoginResponseDto> login(LoginRequestDto request);
}

final class FakeAuthenticationRemoteDatasource
    implements AuthenticationRemoteDatasource {
  const FakeAuthenticationRemoteDatasource({
    this.responseDelay = const Duration(milliseconds: 450),
  });

  final Duration responseDelay;

  @override
  Future<LoginResponseDto> login(LoginRequestDto request) async {
    await Future<void>.delayed(responseDelay);

    if (request.email != 'demo@example.com' ||
        request.password != 'password123') {
      throw const UnauthorizedAppException(
        message: 'The demo credentials were rejected.',
      );
    }

    return LoginResponseDto.fromJson(const <String, Object?>{
      'id': 'user-1',
      'email': 'demo@example.com',
      'display_name': 'Demo User',
      'access_token': 'demo-access-token',
    });
  }
}
