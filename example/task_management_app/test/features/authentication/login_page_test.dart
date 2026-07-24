import 'dart:async';

import 'package:ai_first_flutter_starter/core/errors/failure.dart';
import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/test_data.dart';
import '../../helpers/test_doubles.dart';

void main() {
  testWidgets('shows the reference login flow and demo credentials', (
    tester,
  ) async {
    await tester.pumpStarterApp(
      authenticationRepository: FakeAuthenticationRepository(),
    );

    expect(find.byKey(const Key('login-page')), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.textContaining(TestData.email), findsOneWidget);
  });

  testWidgets('validates empty credentials before login', (tester) async {
    final repository = FakeAuthenticationRepository();
    await tester.pumpStarterApp(authenticationRepository: repository);

    await tester.tap(find.widgetWithText(AppButton, 'Sign in'));
    await tester.pump();

    expect(find.text('Enter your email address.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);
    expect(repository.loginCallCount, 0);
  });

  testWidgets('disables the action and shows progress while logging in', (
    tester,
  ) async {
    final repository = FakeAuthenticationRepository()
      ..loginCompleter = Completer();
    await tester.pumpStarterApp(authenticationRepository: repository);

    await tester.enterText(
      find.byKey(const Key('email-field')),
      TestData.email,
    );
    await tester.enterText(
      find.byKey(const Key('password-field')),
      TestData.password,
    );
    await tester.tap(find.widgetWithText(AppButton, 'Sign in'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    repository.loginCompleter!.complete(
      const FailureResult(UnknownFailure()),
    );
    await tester.pumpAndSettle();

    expect(find.text(const UnknownFailure().userMessage), findsOneWidget);
  });

  testWidgets('redirects to home after successful login', (tester) async {
    final repository = FakeAuthenticationRepository()
      ..loginResult = const Success(TestData.user);
    await tester.pumpStarterApp(authenticationRepository: repository);

    await tester.enterText(
      find.byKey(const Key('email-field')),
      TestData.email,
    );
    await tester.enterText(
      find.byKey(const Key('password-field')),
      TestData.password,
    );
    await tester.tap(find.widgetWithText(AppButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home-page')), findsOneWidget);
    expect(find.text(TestData.displayName), findsOneWidget);
  });
}
