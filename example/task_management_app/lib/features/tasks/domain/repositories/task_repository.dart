import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task.dart';

abstract interface class TaskRepository {
  Future<Result<List<Task>>> getTasks();

  Future<Result<Task>> create({
    required String title,
    required String description,
  });

  Future<Result<Task>> update(Task task);

  Future<Result<Task>> toggle(String id);

  Future<Result<void>> delete(String id);
}
