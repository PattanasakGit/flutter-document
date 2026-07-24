import 'package:ai_first_flutter_starter/features/tasks/data/datasources/task_local_datasource.dart';

abstract final class TaskSeed {
  static const defaults = <TaskRecord>[
    TaskRecord(
      id: 'task-welcome',
      title: 'Read the Flutter field guide',
      description: 'Follow the learning tracks from Dart to release.',
      completed: false,
      createdAtIso: '2026-07-24T01:00:00.000Z',
    ),
    TaskRecord(
      id: 'task-test',
      title: 'Run the complete test suite',
      description: 'Use focused tests first, then verify the full project.',
      completed: false,
      createdAtIso: '2026-07-24T02:00:00.000Z',
    ),
    TaskRecord(
      id: 'task-baseline',
      title: 'Confirm the boilerplate baseline',
      description: 'Analyze and test before adding product behavior.',
      completed: true,
      createdAtIso: '2026-07-24T03:00:00.000Z',
    ),
  ];
}
