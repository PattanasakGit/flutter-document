import 'package:ai_first_flutter_starter/core/errors/error_mapper.dart';
import 'package:ai_first_flutter_starter/core/errors/failure.dart';
import 'package:ai_first_flutter_starter/core/logging/app_logger.dart';
import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/dtos/task_dto.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/dtos/task_write_request_dto.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/repositories/remote_task_repository.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _FakeTaskRemoteDatasource datasource;
  late RemoteTaskRepository repository;

  setUp(() {
    datasource = _FakeTaskRemoteDatasource();
    repository = RemoteTaskRepository(
      datasource: datasource,
      errorMapper: const ErrorMapper(),
      logger: const NoOpAppLogger(),
    );
  });

  test('maps checked response DTOs into validated domain tasks', () async {
    datasource.tasks = [_dto()];

    final result = await repository.getTasks();

    expect(result, isA<Success<List<Task>>>());
    expect((result as Success<List<Task>>).data.single.id, 'task-1');
  });

  test('maps a DTO that violates domain rules to SchemaFailure', () async {
    datasource.tasks = [_dto(title: '   ')];

    final result = await repository.getTasks();

    expect(result, isA<FailureResult<List<Task>>>());
    expect(
      (result as FailureResult<List<Task>>).failure,
      isA<SchemaFailure>(),
    );
  });

  test(
    'forwards create, update, toggle, and delete through typed results',
    () async {
      final created = await repository.create(
        title: 'Create remote task',
        description: 'Through a request DTO',
      );
      final task = (created as Success<Task>).data;
      final edited =
          (task.updateContent(
                    title: 'Edited remote task',
                    description: 'Still typed',
                  )
                  as Success<Task>)
              .data;

      final updated = await repository.update(edited);
      final toggled = await repository.toggle(task.id);
      final deleted = await repository.delete(task.id);

      expect(updated, isA<Success<Task>>());
      expect(toggled, isA<Success<Task>>());
      expect(deleted, isA<Success<void>>());
      expect(datasource.lastCreate?.title, 'Create remote task');
      expect(datasource.lastUpdate?.completed, isFalse);
      expect(datasource.deletedId, task.id);
    },
  );
}

TaskDto _dto({
  String title = 'Remote task',
  bool completed = false,
}) {
  return TaskDto(
    id: 'task-1',
    title: title,
    description: '',
    completed: completed,
    createdAt: DateTime.utc(2026, 7, 24),
  );
}

final class _FakeTaskRemoteDatasource implements TaskRemoteDatasource {
  List<TaskDto> tasks = [];
  CreateTaskRequestDto? lastCreate;
  TaskUpdateRequestDto? lastUpdate;
  String? deletedId;

  @override
  Future<TaskDto> create(CreateTaskRequestDto request) async {
    lastCreate = request;
    return _dto(title: request.title);
  }

  @override
  Future<void> delete(String id) async {
    deletedId = id;
  }

  @override
  Future<List<TaskDto>> readAll() async => tasks;

  @override
  Future<TaskDto> toggle(String id) async {
    return _dto(completed: true);
  }

  @override
  Future<TaskDto> update(String id, TaskUpdateRequestDto request) async {
    lastUpdate = request;
    return _dto(title: request.title, completed: request.completed);
  }
}
