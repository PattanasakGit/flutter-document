import 'package:ai_first_flutter_starter/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('runs its action when enabled', (tester) async {
    var callCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: AppButton(
          label: 'Continue',
          onPressed: () => callCount += 1,
        ),
      ),
    );

    await tester.tap(find.text('Continue'));

    expect(callCount, 1);
  });

  testWidgets('shows progress and blocks its action while loading', (
    tester,
  ) async {
    var callCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: AppButton(
          label: 'Continue',
          isLoading: true,
          onPressed: () => callCount += 1,
        ),
      ),
    );

    await tester.tap(find.byType(FilledButton));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(callCount, 0);
  });
}
