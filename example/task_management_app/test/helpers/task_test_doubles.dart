import 'dart:async';

import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/repositories/task_repository.dart';

final class FakeTaskRepository implements TaskRepository {
  FakeTaskRepository({List<Task> seed = const []}) : tasks = [...seed];

  final List<Task> tasks;
  int createCallCount = 0;
  int toggleCallCount = 0;
  int deleteCallCount = 0;
  int updateCallCount = 0;
  Completer<Result<List<Task>>>? getTasksCompleter;
  Result<List<Task>>? getTasksResult;

  @override
  Future<Result<Task>> create({
    required String title,
    required String description,
  }) async {
    createCallCount += 1;
    final result = Task.create(
      id: 'created-$createCallCount',
      title: title,
      description: description,
      createdAt: DateTime.utc(2026, 7, 24, createCallCount),
    );
    if (result case Success<Task>(:final data)) {
      tasks.add(data);
    }
    return result;
  }

  @override
  Future<Result<void>> delete(String id) async {
    deleteCallCount += 1;
    tasks.removeWhere((task) => task.id == id);
    return const Success(null);
  }

  @override
  Future<Result<List<Task>>> getTasks() async {
    return getTasksCompleter?.future ??
        getTasksResult ??
        Success(List.of(tasks));
  }

  @override
  Future<Result<Task>> toggle(String id) async {
    toggleCallCount += 1;
    final index = tasks.indexWhere((task) => task.id == id);
    final toggled = tasks[index].toggle();
    tasks[index] = toggled;
    return Success(toggled);
  }

  @override
  Future<Result<Task>> update(Task task) async {
    updateCallCount += 1;
    final index = tasks.indexWhere((existing) => existing.id == task.id);
    tasks[index] = task;
    return Success(task);
  }
}
