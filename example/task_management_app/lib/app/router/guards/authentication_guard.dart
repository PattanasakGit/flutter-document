import 'package:ai_first_flutter_starter/app/router/route_paths.dart';

final class AuthenticationGuard {
  const AuthenticationGuard();

  String? redirect({
    required bool isAuthenticated,
    required String location,
  }) {
    final isOnLogin = location == RoutePaths.login;
    if (!isAuthenticated && !isOnLogin) {
      return RoutePaths.login;
    }
    if (isAuthenticated && isOnLogin) {
      return RoutePaths.home;
    }
    return null;
  }
}
