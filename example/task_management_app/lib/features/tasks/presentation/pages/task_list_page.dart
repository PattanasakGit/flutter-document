import 'package:ai_first_flutter_starter/app/theme/app_spacing.dart';
import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task.dart';
import 'package:ai_first_flutter_starter/features/tasks/presentation/controllers/task_list_controller.dart';
import 'package:ai_first_flutter_starter/features/tasks/presentation/states/task_list_state.dart';
import 'package:ai_first_flutter_starter/features/tasks/presentation/widgets/task_card.dart';
import 'package:ai_first_flutter_starter/features/tasks/presentation/widgets/task_filter_bar.dart';
import 'package:ai_first_flutter_starter/features/tasks/presentation/widgets/task_form_sheet.dart';
import 'package:ai_first_flutter_starter/shared/widgets/app_empty_view.dart';
import 'package:ai_first_flutter_starter/shared/widgets/app_error_view.dart';
import 'package:ai_first_flutter_starter/shared/widgets/app_loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class TaskListPage extends ConsumerWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskListControllerProvider);
    return Scaffold(
      key: const Key('task-list-page'),
      appBar: AppBar(
        title: const Text('Task field board'),
        actions: [
          IconButton(
            tooltip: 'Reload tasks',
            onPressed: switch (state) {
              TaskListLoading() => null,
              TaskListReady(:final isMutating) when isMutating => null,
              _ => () => ref.read(taskListControllerProvider.notifier).load(),
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: switch (state) {
        TaskListLoading() => const AppLoadingView(label: 'Loading tasks'),
        TaskListFailed(:final failure) => AppErrorView(
          title: 'Tasks unavailable',
          message: failure.userMessage,
          actionLabel: 'Try again',
          onAction: () => ref.read(taskListControllerProvider.notifier).load(),
        ),
        TaskListReady() => _ReadyTaskList(state: state),
      },
      floatingActionButton: state is TaskListReady
          ? FloatingActionButton.extended(
              tooltip: 'Add task',
              onPressed: state.isMutating
                  ? null
                  : () => _createTask(context, ref),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add task'),
            )
          : null,
    );
  }

  Future<void> _createTask(BuildContext context, WidgetRef ref) async {
    final value = await showTaskFormSheet(context);
    if (value == null) return;
    await ref
        .read(taskListControllerProvider.notifier)
        .create(title: value.title, description: value.description);
  }
}

final class _ReadyTaskList extends ConsumerWidget {
  const _ReadyTaskList({required this.state});

  final TaskListReady state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(taskListControllerProvider.notifier);
    final visibleTasks = state.visibleTasks;
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            112,
          ),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _TaskSummary(state: state),
                    const SizedBox(height: AppSpacing.lg),
                    TaskFilterBar(
                      value: state.filter,
                      onChanged: state.isMutating ? null : controller.setFilter,
                    ),
                    if (state.actionError case final message?) ...[
                      const SizedBox(height: AppSpacing.md),
                      _ActionErrorBanner(
                        message: message,
                        onDismiss: controller.clearActionError,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    if (visibleTasks.isEmpty)
                      const SizedBox(
                        height: 260,
                        child: AppEmptyView(
                          title: 'No tasks in this view',
                          message:
                              'Create a task or choose another filter to '
                              'continue.',
                        ),
                      )
                    else
                      for (final task in visibleTasks) ...[
                        TaskCard(
                          task: task,
                          isDisabled: state.isMutating,
                          onToggle: () => controller.toggle(task.id),
                          onEdit: () => _editTask(context, ref, task),
                          onDelete: () => _confirmDelete(context, ref, task),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                  ],
                ),
              ),
            ),
          ],
        ),
        if (state.isMutating)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(),
          ),
      ],
    );
  }

  Future<void> _editTask(
    BuildContext context,
    WidgetRef ref,
    Task task,
  ) async {
    final value = await showTaskFormSheet(context, initialTask: task);
    if (value == null) return;
    final result = task.updateContent(
      title: value.title,
      description: value.description,
    );
    switch (result) {
      case Success<Task>(:final data):
        await ref.read(taskListControllerProvider.notifier).update(data);
      case FailureResult<Task>(:final failure):
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.userMessage)),
        );
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Task task,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text(
          '“${task.title}” will be removed from this offline example.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(taskListControllerProvider.notifier).delete(task.id);
    }
  }
}

final class _TaskSummary extends StatelessWidget {
  const _TaskSummary({required this.state});

  final TaskListReady state;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 560;
            final copy = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EXECUTION QUEUE',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${state.openCount} open · ${state.tasks.length} total',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                const Text(
                  'A deterministic offline feature built across domain, '
                  'data, Riverpod, and presentation boundaries.',
                ),
              ],
            );
            final progress = _ProgressRing(
              completed: state.tasks.length - state.openCount,
              total: state.tasks.length,
            );
            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  copy,
                  const SizedBox(height: AppSpacing.lg),
                  progress,
                ],
              );
            }
            return Row(
              children: [
                Expanded(child: copy),
                const SizedBox(width: AppSpacing.lg),
                progress,
              ],
            );
          },
        ),
      ),
    );
  }
}

final class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.completed, required this.total});

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final value = total == 0 ? 0.0 : completed / total;
    return Semantics(
      label: '$completed of $total tasks completed',
      child: SizedBox.square(
        dimension: 72,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(value: value, strokeWidth: 7),
            Text('$completed/$total'),
          ],
        ),
      ),
    );
  }
}

final class _ActionErrorBanner extends StatelessWidget {
  const _ActionErrorBanner({
    required this.message,
    required this.onDismiss,
  });

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(message)),
              IconButton(
                tooltip: 'Dismiss error',
                onPressed: onDismiss,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
