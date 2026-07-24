import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/repositories/task_repository.dart';

final class GetTasks {
  const GetTasks(this._repository);

  final TaskRepository _repository;

  Future<Result<List<Task>>> call() => _repository.getTasks();
}

final class CreateTask {
  const CreateTask(this._repository);

  final TaskRepository _repository;

  Future<Result<Task>> call({
    required String title,
    required String description,
  }) {
    return _repository.create(title: title, description: description);
  }
}

final class UpdateTask {
  const UpdateTask(this._repository);

  final TaskRepository _repository;

  Future<Result<Task>> call(Task task) => _repository.update(task);
}

final class ToggleTask {
  const ToggleTask(this._repository);

  final TaskRepository _repository;

  Future<Result<Task>> call(String id) => _repository.toggle(id);
}

final class DeleteTask {
  const DeleteTask(this._repository);

  final TaskRepository _repository;

  Future<Result<void>> call(String id) => _repository.delete(id);
}
