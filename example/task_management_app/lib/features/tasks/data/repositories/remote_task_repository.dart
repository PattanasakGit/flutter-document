import 'package:ai_first_flutter_starter/core/errors/app_exception.dart';
import 'package:ai_first_flutter_starter/core/errors/error_mapper.dart';
import 'package:ai_first_flutter_starter/core/logging/app_logger.dart';
import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/dtos/task_dto.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/dtos/task_write_request_dto.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/repositories/task_repository.dart';

final class RemoteTaskRepository implements TaskRepository {
  factory RemoteTaskRepository({
    required TaskRemoteDatasource datasource,
    required ErrorMapper errorMapper,
    required AppLogger logger,
  }) {
    return RemoteTaskRepository._(datasource, errorMapper, logger);
  }

  const RemoteTaskRepository._(
    this._datasource,
    this._errorMapper,
    this._logger,
  );

  final TaskRemoteDatasource _datasource;
  final ErrorMapper _errorMapper;
  final AppLogger _logger;

  @override
  Future<Result<List<Task>>> getTasks() {
    return _guard(() async {
      final dtos = await _datasource.readAll();
      return dtos.map(_toEntity).toList(growable: false);
    });
  }

  @override
  Future<Result<Task>> create({
    required String title,
    required String description,
  }) async {
    final candidate = Task.create(
      id: 'request-validation',
      title: title,
      description: description,
      createdAt: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
    return switch (candidate) {
      FailureResult<Task>(:final failure) => FailureResult(failure),
      Success<Task>(:final data) => _guard(() async {
        final dto = await _datasource.create(
          CreateTaskRequestDto(
            title: data.title,
            description: data.description,
          ),
        );
        return _toEntity(dto);
      }),
    };
  }

  @override
  Future<Result<Task>> update(Task task) {
    return _guard(() async {
      final dto = await _datasource.update(
        task.id,
        TaskUpdateRequestDto(
          title: task.title,
          description: task.description,
          completed: task.isCompleted,
        ),
      );
      return _toEntity(dto);
    });
  }

  @override
  Future<Result<Task>> toggle(String id) {
    return _guard(() async => _toEntity(await _datasource.toggle(id)));
  }

  @override
  Future<Result<void>> delete(String id) {
    return _guard(() => _datasource.delete(id));
  }

  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on Object catch (error, stackTrace) {
      _logger.error(
        'Remote task repository operation failed.',
        error: error,
        stackTrace: stackTrace,
      );
      return FailureResult(_errorMapper.mapException(error));
    }
  }

  Task _toEntity(TaskDto dto) {
    return switch (Task.restore(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      isCompleted: dto.completed,
      createdAt: dto.createdAt,
    )) {
      Success<Task>(:final data) => data,
      FailureResult<Task>(:final failure) => throw SchemaAppException(
        message: 'Remote task violates domain rules: ${failure.userMessage}',
      ),
    };
  }
}
