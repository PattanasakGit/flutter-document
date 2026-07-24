import 'package:ai_first_flutter_starter/core/errors/error_mapper.dart';
import 'package:ai_first_flutter_starter/core/errors/failure.dart';
import 'package:ai_first_flutter_starter/core/logging/app_logger.dart';
import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/repositories/task_repository.dart';

typedef IdGenerator = String Function();
typedef Clock = DateTime Function();

final class TaskRepositoryImpl implements TaskRepository {
  factory TaskRepositoryImpl({
    required TaskLocalDatasource datasource,
    required IdGenerator idGenerator,
    required Clock clock,
    required ErrorMapper errorMapper,
    required AppLogger logger,
  }) {
    return TaskRepositoryImpl._(
      datasource,
      idGenerator,
      clock,
      errorMapper,
      logger,
    );
  }

  const TaskRepositoryImpl._(
    this._datasource,
    this._idGenerator,
    this._clock,
    this._errorMapper,
    this._logger,
  );

  final TaskLocalDatasource _datasource;
  final IdGenerator _idGenerator;
  final Clock _clock;
  final ErrorMapper _errorMapper;
  final AppLogger _logger;

  @override
  Future<Result<List<Task>>> getTasks() async {
    try {
      final records = await _datasource.readAll();
      final tasks = <Task>[];
      for (final record in records) {
        switch (_toEntity(record)) {
          case Success<Task>(:final data):
            tasks.add(data);
          case FailureResult<Task>(:final failure):
            return FailureResult(failure);
        }
      }
      return Success(List.unmodifiable(tasks));
    } on Object catch (error, stackTrace) {
      return _failure(
        operation: 'read',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<Result<Task>> create({
    required String title,
    required String description,
  }) async {
    final candidate = Task.create(
      id: _idGenerator(),
      title: title,
      description: description,
      createdAt: _clock(),
    );
    return switch (candidate) {
      Success<Task>(:final data) => _insert(data),
      FailureResult<Task>(:final failure) => FailureResult(failure),
    };
  }

  @override
  Future<Result<Task>> update(Task task) => _update(task);

  @override
  Future<Result<Task>> toggle(String id) async {
    try {
      final record = await _datasource.readById(id);
      if (record == null) {
        return const FailureResult(
          NotFoundFailure(
            userMessage: 'The task could not be found.',
          ),
        );
      }
      return switch (_toEntity(record)) {
        Success<Task>(:final data) => _update(data.toggle()),
        FailureResult<Task>(:final failure) => FailureResult(failure),
      };
    } on Object catch (error, stackTrace) {
      return _failure(
        operation: 'toggle',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      final deleted = await _datasource.delete(id);
      if (!deleted) {
        return const FailureResult(
          NotFoundFailure(
            userMessage: 'The task could not be found.',
          ),
        );
      }
      return const Success(null);
    } on Object catch (error, stackTrace) {
      return _failure(
        operation: 'delete',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<Result<Task>> _insert(Task task) async {
    try {
      final record = await _datasource.insert(_toRecord(task));
      if (record == null) {
        return const FailureResult(
          ValidationFailure(
            userMessage: 'A task with this identity already exists.',
          ),
        );
      }
      return _toEntity(record);
    } on Object catch (error, stackTrace) {
      return _failure(
        operation: 'create',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<Result<Task>> _update(Task task) async {
    try {
      final record = await _datasource.update(_toRecord(task));
      if (record == null) {
        return const FailureResult(
          NotFoundFailure(
            userMessage: 'The task could not be found.',
          ),
        );
      }
      return _toEntity(record);
    } on Object catch (error, stackTrace) {
      return _failure(
        operation: 'update',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  FailureResult<T> _failure<T>({
    required String operation,
    required Object error,
    required StackTrace stackTrace,
  }) {
    _logger.error(
      'Task repository $operation failed.',
      error: error,
      stackTrace: stackTrace,
    );
    return FailureResult(_errorMapper.mapException(error));
  }

  Result<Task> _toEntity(TaskRecord record) {
    final createdAt = DateTime.tryParse(record.createdAtIso);
    if (createdAt == null) {
      return const FailureResult(
        ValidationFailure(
          userMessage: 'Stored task data is invalid.',
        ),
      );
    }
    return Task.restore(
      id: record.id,
      title: record.title,
      description: record.description,
      isCompleted: record.completed,
      createdAt: createdAt,
    );
  }

  TaskRecord _toRecord(Task task) {
    return TaskRecord(
      id: task.id,
      title: task.title,
      description: task.description,
      completed: task.isCompleted,
      createdAtIso: task.createdAt.toUtc().toIso8601String(),
    );
  }
}
