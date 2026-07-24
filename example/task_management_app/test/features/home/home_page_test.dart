import 'dart:async';

import 'package:ai_first_flutter_starter/core/errors/failure.dart';
import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/features/authentication/presentation/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/test_data.dart';
import '../../helpers/test_doubles.dart';

void main() {
  testWidgets('logs out and redirects to login', (tester) async {
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

    await tester.ensureVisible(find.text('Sign out'));
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    expect(repository.logoutCallCount, 1);
    expect(find.byKey(const Key('login-page')), findsOneWidget);
  });

  testWidgets('shows progress and a safe message when logout fails', (
    tester,
  ) async {
    final repository = FakeAuthenticationRepository()
      ..loginResult = const Success(TestData.user)
      ..logoutCompleter = Completer();
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

    await tester.ensureVisible(find.text('Sign out'));
    await tester.tap(find.text('Sign out'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    repository.logoutCompleter!.complete(
      const FailureResult(UnknownFailure()),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home-page')), findsOneWidget);
    expect(find.text(const UnknownFailure().userMessage), findsOneWidget);
  });
}
