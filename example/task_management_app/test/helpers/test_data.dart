import 'package:ai_first_flutter_starter/features/authentication/domain/entities/authenticated_user.dart';

abstract final class TestData {
  static const email = 'demo@example.com';
  static const password = 'password123';
  static const token = 'demo-access-token';
  static const userId = 'user-1';
  static const displayName = 'Demo User';
  static const user = AuthenticatedUser(
    id: userId,
    email: email,
    displayName: displayName,
  );

  static const loginResponseJson = <String, Object?>{
    'id': userId,
    'email': email,
    'display_name': displayName,
    'access_token': token,
  };
}
