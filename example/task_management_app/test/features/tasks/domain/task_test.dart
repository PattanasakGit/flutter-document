import 'package:ai_first_flutter_starter/core/errors/failure.dart';
import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Task', () {
    test('creates a task with normalized content', () {
      final result = Task.create(
        id: 'task-1',
        title: '  Learn Dart  ',
        description: '  Practice immutable models  ',
        createdAt: DateTime.utc(2026, 7, 24),
      );

      expect(result, isA<Success<Task>>());
      final task = (result as Success<Task>).data;
      expect(task.title, 'Learn Dart');
      expect(task.description, 'Practice immutable models');
      expect(task.isCompleted, isFalse);
    });

    test('rejects a blank title with a validation failure', () {
      final result = Task.create(
        id: 'task-1',
        title: '   ',
        createdAt: DateTime.utc(2026, 7, 24),
      );

      expect(result, isA<FailureResult<Task>>());
      expect(
        (result as FailureResult<Task>).failure,
        isA<ValidationFailure>(),
      );
    });

    test('rejects content beyond the domain limits', () {
      final longTitle = List.filled(121, 'a').join();
      final longDescription = List.filled(501, 'b').join();

      final titleResult = Task.create(
        id: 'task-1',
        title: longTitle,
        createdAt: DateTime.utc(2026, 7, 24),
      );
      final descriptionResult = Task.create(
        id: 'task-1',
        title: 'Valid title',
        description: longDescription,
        createdAt: DateTime.utc(2026, 7, 24),
      );

      expect(titleResult, isA<FailureResult<Task>>());
      expect(descriptionResult, isA<FailureResult<Task>>());
    });

    test('rejects malformed persisted content during restoration', () {
      final result = Task.restore(
        id: 'task-1',
        title: '   ',
        description: '',
        isCompleted: false,
        createdAt: DateTime.utc(2026, 7, 24),
      );

      expect(result, isA<FailureResult<Task>>());
    });

    test('updates content without changing identity or creation time', () {
      final original =
          (Task.restore(
                    id: 'task-1',
                    title: 'Draft',
                    description: '',
                    isCompleted: true,
                    createdAt: DateTime.utc(2026, 7, 24),
                  )
                  as Success<Task>)
              .data;

      final result = original.updateContent(
        title: '  Published  ',
        description: '  Ready for review  ',
      );

      final updated = (result as Success<Task>).data;
      expect(updated.id, original.id);
      expect(updated.createdAt, original.createdAt);
      expect(updated.isCompleted, original.isCompleted);
      expect(updated.title, 'Published');
      expect(updated.description, 'Ready for review');
    });

    test('toggle changes only completion state', () {
      final task =
          (Task.restore(
                    id: 'task-1',
                    title: 'Test state',
                    description: 'Keep this',
                    isCompleted: false,
                    createdAt: DateTime.utc(2026, 7, 24),
                  )
                  as Success<Task>)
              .data;

      final toggled = task.toggle();

      expect(toggled.id, task.id);
      expect(toggled.title, task.title);
      expect(toggled.description, task.description);
      expect(toggled.createdAt, task.createdAt);
      expect(toggled.isCompleted, isTrue);
    });
  });

  group('TaskFilter', () {
    final openTask =
        (Task.restore(
                  id: 'open',
                  title: 'Open',
                  description: '',
                  isCompleted: false,
                  createdAt: DateTime.utc(2026, 7, 24),
                )
                as Success<Task>)
            .data;
    final completedTask =
        (Task.restore(
                  id: 'done',
                  title: 'Done',
                  description: '',
                  isCompleted: true,
                  createdAt: DateTime.utc(2026, 7, 24),
                )
                as Success<Task>)
            .data;

    test('all matches every completion state', () {
      expect(TaskFilter.all.matches(openTask), isTrue);
      expect(TaskFilter.all.matches(completedTask), isTrue);
    });

    test('open and completed match their respective states', () {
      expect(TaskFilter.open.matches(openTask), isTrue);
      expect(TaskFilter.open.matches(completedTask), isFalse);
      expect(TaskFilter.completed.matches(openTask), isFalse);
      expect(TaskFilter.completed.matches(completedTask), isTrue);
    });
  });
}
