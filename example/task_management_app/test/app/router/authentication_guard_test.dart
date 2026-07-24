import 'package:ai_first_flutter_starter/app/router/guards/authentication_guard.dart';
import 'package:ai_first_flutter_starter/app/router/route_paths.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const guard = AuthenticationGuard();

  test('redirects a signed-out user from home to login', () {
    final redirect = guard.redirect(
      isAuthenticated: false,
      location: RoutePaths.home,
    );

    expect(redirect, RoutePaths.login);
  });

  test('defaults to login for any non-public route when signed out', () {
    final redirect = guard.redirect(
      isAuthenticated: false,
      location: '/future-protected-route',
    );

    expect(redirect, RoutePaths.login);
  });

  test('redirects a signed-in user away from login to home', () {
    final redirect = guard.redirect(
      isAuthenticated: true,
      location: RoutePaths.login,
    );

    expect(redirect, RoutePaths.home);
  });

  test('allows a signed-in user to remain on home', () {
    final redirect = guard.redirect(
      isAuthenticated: true,
      location: RoutePaths.home,
    );

    expect(redirect, isNull);
  });
}
