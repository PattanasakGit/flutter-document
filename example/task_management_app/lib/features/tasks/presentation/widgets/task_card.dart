import 'package:ai_first_flutter_starter/app/theme/app_spacing.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task.dart';
import 'package:flutter/material.dart';

final class TaskCard extends StatelessWidget {
  const TaskCard({
    required this.task,
    required this.isDisabled,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final Task task;
  final bool isDisabled;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              label: task.isCompleted
                  ? 'Mark ${task.title} as open'
                  : 'Mark ${task.title} as completed',
              child: Checkbox(
                key: Key('task-toggle-${task.id}'),
                value: task.isCompleted,
                onChanged: isDisabled ? null : (_) => onToggle(),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: textTheme.titleMedium?.copyWith(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (task.description.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(task.description, style: textTheme.bodyMedium),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  _StatusLabel(isCompleted: task.isCompleted),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            IconButton(
              key: Key('task-edit-${task.id}'),
              tooltip: 'Edit ${task.title}',
              onPressed: isDisabled ? null : onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              key: Key('task-delete-${task.id}'),
              tooltip: 'Delete ${task.title}',
              onPressed: isDisabled ? null : onDelete,
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

final class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.isCompleted});

  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isCompleted ? colorScheme.secondary : colorScheme.primary;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          isCompleted ? 'COMPLETED' : 'OPEN',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
        ),
      ),
    );
  }
}
