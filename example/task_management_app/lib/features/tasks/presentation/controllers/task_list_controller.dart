import 'dart:async';

import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task_filter.dart';
import 'package:ai_first_flutter_starter/features/tasks/presentation/states/task_list_state.dart';
import 'package:ai_first_flutter_starter/features/tasks/tasks_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_list_controller.g.dart';

@Riverpod(keepAlive: true)
class TaskListController extends _$TaskListController {
  var _loadGeneration = 0;

  @override
  TaskListState build() {
    unawaited(Future<void>.microtask(load));
    return const TaskListState.loading();
  }

  Future<void> load() async {
    final current = state;
    if (current is TaskListReady && current.isMutating) return;

    final generation = ++_loadGeneration;
    state = const TaskListState.loading();
    final result = await ref.read(getTasksProvider).call();
    if (generation != _loadGeneration) return;
    state = switch (result) {
      Success<List<Task>>(:final data) => TaskListState.ready(tasks: data),
      FailureResult<List<Task>>(:final failure) => TaskListState.failed(
        failure,
      ),
    };
  }

  void setFilter(TaskFilter filter) {
    final current = state;
    if (current is TaskListReady && !current.isMutating) {
      state = current.copyWith(filter: filter);
    }
  }

  void clearActionError() {
    final current = state;
    if (current is TaskListReady && current.actionError != null) {
      state = current.copyWith(actionError: null);
    }
  }

  Future<void> create({
    required String title,
    required String description,
  }) async {
    final current = _beginMutation();
    if (current == null) return;

    final result = await ref
        .read(createTaskProvider)
        .call(title: title, description: description);
    state = switch (result) {
      Success<Task>(:final data) => current.copyWith(
        tasks: [...current.tasks, data],
        isMutating: false,
      ),
      FailureResult<Task>(:final failure) => current.copyWith(
        isMutating: false,
        actionError: failure.userMessage,
      ),
    };
  }

  Future<void> update(Task task) async {
    final current = _beginMutation();
    if (current == null) return;

    final result = await ref.read(updateTaskProvider).call(task);
    state = switch (result) {
      Success<Task>(:final data) => current.copyWith(
        tasks: [
          for (final existing in current.tasks)
            if (existing.id == data.id) data else existing,
        ],
        isMutating: false,
      ),
      FailureResult<Task>(:final failure) => current.copyWith(
        isMutating: false,
        actionError: failure.userMessage,
      ),
    };
  }

  Future<void> toggle(String id) async {
    final current = _beginMutation();
    if (current == null) return;

    final result = await ref.read(toggleTaskProvider).call(id);
    state = switch (result) {
      Success<Task>(:final data) => current.copyWith(
        tasks: [
          for (final existing in current.tasks)
            if (existing.id == data.id) data else existing,
        ],
        isMutating: false,
      ),
      FailureResult<Task>(:final failure) => current.copyWith(
        isMutating: false,
        actionError: failure.userMessage,
      ),
    };
  }

  Future<void> delete(String id) async {
    final current = _beginMutation();
    if (current == null) return;

    final result = await ref.read(deleteTaskProvider).call(id);
    state = switch (result) {
      Success<void>() => current.copyWith(
        tasks: current.tasks.where((task) => task.id != id).toList(),
        isMutating: false,
      ),
      FailureResult<void>(:final failure) => current.copyWith(
        isMutating: false,
        actionError: failure.userMessage,
      ),
    };
  }

  TaskListReady? _beginMutation() {
    final current = state;
    if (current is! TaskListReady || current.isMutating) return null;
    state = current.copyWith(isMutating: true, actionError: null);
    return current;
  }
}
