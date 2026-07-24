import 'package:ai_first_flutter_starter/core/errors/failure.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task_filter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_list_state.freezed.dart';

@freezed
sealed class TaskListState with _$TaskListState {
  const factory TaskListState.loading() = TaskListLoading;

  const factory TaskListState.ready({
    required List<Task> tasks,
    @Default(TaskFilter.all) TaskFilter filter,
    @Default(false) bool isMutating,
    String? actionError,
  }) = TaskListReady;

  const factory TaskListState.failed(Failure failure) = TaskListFailed;
}

extension TaskListReadyView on TaskListReady {
  List<Task> get visibleTasks {
    return tasks.where(filter.matches).toList(growable: false);
  }

  int get openCount => tasks.where((task) => !task.isCompleted).length;
}
