import 'package:ai_first_flutter_starter/core/errors/error_mapper.dart';
import 'package:ai_first_flutter_starter/core/errors/failure.dart';
import 'package:ai_first_flutter_starter/core/logging/app_logger.dart';
import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/datasources/in_memory_task_datasource.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InMemoryTaskDatasource datasource;
  late TaskRepositoryImpl repository;

  setUp(() {
    datasource = InMemoryTaskDatasource();
    repository = TaskRepositoryImpl(
      datasource: datasource,
      idGenerator: () => 'task-test-1',
      clock: () => DateTime.utc(2026, 7, 24),
      errorMapper: const ErrorMapper(),
      logger: const NoOpAppLogger(),
    );
  });

  test(
    'create uses deterministic dependencies and maps a normalized task',
    () async {
      final result = await repository.create(
        title: '  Learn repositories  ',
        description: '  Keep boundaries explicit  ',
      );

      expect(result, isA<Success<Task>>());
      final task = (result as Success<Task>).data;
      expect(task.id, 'task-test-1');
      expect(task.createdAt, DateTime.utc(2026, 7, 24));
      expect(task.title, 'Learn repositories');
      expect((await datasource.readAll()).single.title, task.title);
    },
  );

  test('getTasks maps records and preserves datasource order', () async {
    await datasource.insert(
      const TaskRecord(
        id: 'one',
        title: 'One',
        description: '',
        completed: false,
        createdAtIso: '2026-07-24T01:00:00.000Z',
      ),
    );
    await datasource.insert(
      const TaskRecord(
        id: 'two',
        title: 'Two',
        description: '',
        completed: true,
        createdAtIso: '2026-07-24T02:00:00.000Z',
      ),
    );

    final result = await repository.getTasks();

    expect(
      (result as Success<List<Task>>).data.map((task) => task.id),
      ['one', 'two'],
    );
  });

  test('toggle returns not found when the identity is absent', () async {
    final result = await repository.toggle('missing');

    expect(result, isA<FailureResult<Task>>());
    expect(
      (result as FailureResult<Task>).failure,
      isA<NotFoundFailure>(),
    );
  });

  test('create rejects a duplicate generated identity', () async {
    await datasource.insert(
      const TaskRecord(
        id: 'task-test-1',
        title: 'Existing',
        description: '',
        completed: false,
        createdAtIso: '2026-07-24T00:00:00.000Z',
      ),
    );

    final result = await repository.create(
      title: 'Duplicate identity',
      description: '',
    );

    expect(result, isA<FailureResult<Task>>());
    expect(
      (result as FailureResult<Task>).failure,
      isA<ValidationFailure>(),
    );
    expect((await datasource.readAll()).single.title, 'Existing');
  });

  test(
    'update returns not found instead of inserting a missing task',
    () async {
      final task =
          (Task.restore(
                    id: 'missing',
                    title: 'Missing',
                    description: '',
                    isCompleted: false,
                    createdAt: DateTime.utc(2026, 7, 24),
                  )
                  as Success<Task>)
              .data;

      final result = await repository.update(task);

      expect(result, isA<FailureResult<Task>>());
      expect(
        (result as FailureResult<Task>).failure,
        isA<NotFoundFailure>(),
      );
      expect(await datasource.readAll(), isEmpty);
    },
  );

  test('getTasks maps malformed stored content to a typed failure', () async {
    await datasource.insert(
      const TaskRecord(
        id: 'invalid',
        title: '   ',
        description: '',
        completed: false,
        createdAtIso: 'not-a-date',
      ),
    );

    final result = await repository.getTasks();

    expect(result, isA<FailureResult<List<Task>>>());
    expect(
      (result as FailureResult<List<Task>>).failure,
      isA<ValidationFailure>(),
    );
  });

  test('update and delete persist the new snapshot', () async {
    const record = TaskRecord(
      id: 'task-1',
      title: 'Before',
      description: '',
      completed: false,
      createdAtIso: '2026-07-24T00:00:00.000Z',
    );
    await datasource.insert(record);
    final task =
        (Task.restore(
                  id: record.id,
                  title: 'After',
                  description: 'Edited',
                  isCompleted: record.completed,
                  createdAt: DateTime.parse(record.createdAtIso),
                )
                as Success<Task>)
            .data;

    final updateResult = await repository.update(task);
    final deleteResult = await repository.delete(task.id);

    expect(updateResult, isA<Success<Task>>());
    expect(deleteResult, isA<Success<void>>());
    expect(await datasource.readAll(), isEmpty);
  });

  test('maps an unexpected datasource exception to UnknownFailure', () async {
    final failingRepository = TaskRepositoryImpl(
      datasource: _ThrowingTaskDatasource(),
      idGenerator: () => 'unused',
      clock: () => DateTime.utc(2026),
      errorMapper: const ErrorMapper(),
      logger: const NoOpAppLogger(),
    );

    final result = await failingRepository.getTasks();

    expect(result, isA<FailureResult<List<Task>>>());
    expect(
      (result as FailureResult<List<Task>>).failure,
      isA<UnknownFailure>(),
    );
  });
}

final class _ThrowingTaskDatasource implements TaskLocalDatasource {
  @override
  Future<bool> delete(String id) => throw StateError('offline fixture failed');

  @override
  Future<List<TaskRecord>> readAll() {
    throw StateError('offline fixture failed');
  }

  @override
  Future<TaskRecord?> readById(String id) {
    throw StateError('offline fixture failed');
  }

  @override
  Future<TaskRecord?> insert(TaskRecord record) {
    throw StateError('offline fixture failed');
  }

  @override
  Future<TaskRecord?> update(TaskRecord record) {
    throw StateError('offline fixture failed');
  }
}
