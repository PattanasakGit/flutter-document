import 'dart:async';

import 'package:ai_first_flutter_starter/core/errors/failure.dart';
import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task.dart';
import 'package:ai_first_flutter_starter/features/tasks/presentation/pages/task_list_page.dart';
import 'package:ai_first_flutter_starter/features/tasks/tasks_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/task_test_doubles.dart';

void main() {
  testWidgets('shows loading while the initial repository read is pending', (
    tester,
  ) async {
    final repository = FakeTaskRepository()
      ..getTasksCompleter = Completer<Result<List<Task>>>();

    await tester.pumpTaskPage(repository, settle: false);

    expect(find.bySemanticsLabel('Loading tasks'), findsOneWidget);
    repository.getTasksCompleter!.complete(const Success([]));
    await tester.pumpAndSettle();
  });

  testWidgets('shows a recoverable full-page error for initial load failure', (
    tester,
  ) async {
    final repository = FakeTaskRepository()
      ..getTasksResult = const FailureResult(
        NetworkFailure(userMessage: 'Offline for test.'),
      );

    await tester.pumpTaskPage(repository);

    expect(find.text('Tasks unavailable'), findsOneWidget);
    expect(find.text('Offline for test.'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('renders tasks, summary, and accessible primary action', (
    tester,
  ) async {
    final repository = FakeTaskRepository(
      seed: [
        _task(id: 'open', title: 'Open task'),
        _task(id: 'done', title: 'Completed task', isCompleted: true),
      ],
    );

    await tester.pumpTaskPage(repository);

    expect(find.text('Task field board'), findsOneWidget);
    expect(find.text('1 open · 2 total'), findsOneWidget);
    expect(find.text('Open task'), findsOneWidget);
    expect(find.text('Completed task'), findsOneWidget);
    expect(find.text('COMPLETED'), findsOneWidget);
    expect(find.byTooltip('Add task'), findsOneWidget);
  });

  testWidgets('filters the visible list without loading the repository again', (
    tester,
  ) async {
    final repository = FakeTaskRepository(
      seed: [
        _task(id: 'open', title: 'Open task'),
        _task(id: 'done', title: 'Completed task', isCompleted: true),
      ],
    );
    await tester.pumpTaskPage(repository);

    await tester.tap(find.widgetWithText(FilterChip, 'Completed'));
    await tester.pump();

    expect(find.text('Open task'), findsNothing);
    expect(find.text('Completed task'), findsOneWidget);
  });

  testWidgets('validates and creates a task from the form sheet', (
    tester,
  ) async {
    final repository = FakeTaskRepository();
    await tester.pumpTaskPage(repository);

    await tester.tap(find.byTooltip('Add task'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save task'));
    await tester.pump();
    expect(find.text('Enter a task title.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('task-title-field')),
      'Ship the guide',
    );
    await tester.enterText(
      find.byKey(const Key('task-description-field')),
      'Run all checks first',
    );
    await tester.tap(find.text('Save task'));
    await tester.pumpAndSettle();

    expect(repository.createCallCount, 1);
    expect(find.text('Ship the guide'), findsOneWidget);
  });

  testWidgets('toggles and deletes a task through explicit controls', (
    tester,
  ) async {
    final repository = FakeTaskRepository(
      seed: [_task(id: 'one', title: 'Test mutations')],
    );
    await tester.pumpTaskPage(repository);

    await tester.tap(find.byKey(const Key('task-toggle-one')));
    await tester.pump();
    expect(repository.toggleCallCount, 1);

    await tester.tap(find.byKey(const Key('task-delete-one')));
    await tester.pumpAndSettle();
    expect(find.text('Delete task?'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(repository.deleteCallCount, 1);
    expect(find.text('Test mutations'), findsNothing);
    expect(find.text('No tasks in this view'), findsOneWidget);
  });

  testWidgets('edits a task through the validated form sheet', (tester) async {
    final repository = FakeTaskRepository(
      seed: [_task(id: 'one', title: 'Draft title')],
    );
    await tester.pumpTaskPage(repository);

    await tester.tap(find.byKey(const Key('task-edit-one')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('task-title-field')),
      'Published title',
    );
    await tester.tap(find.text('Save task'));
    await tester.pumpAndSettle();

    expect(repository.updateCallCount, 1);
    expect(find.text('Published title'), findsOneWidget);
    expect(find.text('Draft title'), findsNothing);
  });
}

extension on WidgetTester {
  Future<void> pumpTaskPage(
    FakeTaskRepository repository, {
    bool settle = true,
  }) async {
    await pumpWidget(
      ProviderScope(
        overrides: [
          taskRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: TaskListPage()),
      ),
    );
    if (settle) {
      await pumpAndSettle();
    } else {
      await pump();
    }
  }
}

Task _task({
  required String id,
  required String title,
  bool isCompleted = false,
}) {
  return (Task.restore(
            id: id,
            title: title,
            description: 'Example description',
            isCompleted: isCompleted,
            createdAt: DateTime.utc(2026, 7, 24),
          )
          as Success<Task>)
      .data;
}
