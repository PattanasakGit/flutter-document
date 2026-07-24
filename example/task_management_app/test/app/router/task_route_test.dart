import 'package:ai_first_flutter_starter/app/router/app_router.dart';
import 'package:ai_first_flutter_starter/app/router/route_paths.dart';
import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/features/authentication/presentation/controllers/login_controller.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/task_test_doubles.dart';
import '../../helpers/test_data.dart';
import '../../helpers/test_doubles.dart';

void main() {
  testWidgets('home entry opens the authenticated task route', (tester) async {
    final authenticationRepository = FakeAuthenticationRepository()
      ..loginResult = const Success(TestData.user);
    final taskRepository = FakeTaskRepository(
      seed: [
        (Task.restore(
                  id: 'one',
                  title: 'Route-visible task',
                  description: '',
                  isCompleted: false,
                  createdAt: DateTime.utc(2026, 7, 24),
                )
                as Success<Task>)
            .data,
      ],
    );
    final container = await tester.pumpStarterApp(
      authenticationRepository: authenticationRepository,
      taskRepository: taskRepository,
    );
    await container
        .read(loginControllerProvider.notifier)
        .login(email: TestData.email, password: TestData.password);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Open task manager'));
    await tester.tap(find.text('Open task manager'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('task-list-page')), findsOneWidget);
    expect(find.text('Route-visible task'), findsOneWidget);
    expect(
      container.read(goRouterProvider).routeInformationProvider.value.uri.path,
      RoutePaths.tasks,
    );
  });

  testWidgets('signed-out direct task route is redirected to login', (
    tester,
  ) async {
    final container = await tester.pumpStarterApp(
      authenticationRepository: FakeAuthenticationRepository(),
      taskRepository: FakeTaskRepository(),
    );

    container.read(goRouterProvider).go(RoutePaths.tasks);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('login-page')), findsOneWidget);
  });
}
