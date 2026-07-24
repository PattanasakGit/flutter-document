import 'package:ai_first_flutter_starter/app/router/app_router.dart';
import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/features/authentication/presentation/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/test_data.dart';
import '../../helpers/test_doubles.dart';

void main() {
  testWidgets('redirects a signed-out user to login', (tester) async {
    await tester.pumpStarterApp(
      authenticationRepository: FakeAuthenticationRepository(),
    );

    expect(find.byKey(const Key('login-page')), findsOneWidget);
  });

  testWidgets('keeps a signed-in user on home', (tester) async {
    final repository = FakeAuthenticationRepository()
      ..loginResult = const Success(TestData.user);
    final container = await tester.pumpStarterApp(
      authenticationRepository: repository,
    );

    await container
        .read(loginControllerProvider.notifier)
        .login(
          email: TestData.email,
          password: TestData.password,
        );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home-page')), findsOneWidget);
  });

  testWidgets('renders a useful page for an unknown route', (tester) async {
    final repository = FakeAuthenticationRepository()
      ..loginResult = const Success(TestData.user);
    final container = await tester.pumpStarterApp(
      authenticationRepository: repository,
    );

    await container
        .read(loginControllerProvider.notifier)
        .login(
          email: TestData.email,
          password: TestData.password,
        );
    container.read(goRouterProvider).go('/missing');
    await tester.pumpAndSettle();

    expect(find.text('Page not found'), findsOneWidget);
    expect(find.text('Return to start'), findsOneWidget);
  });
}
