import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task_filter.dart';
import 'package:flutter/material.dart';

final class TaskFilterBar extends StatelessWidget {
  const TaskFilterBar({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final TaskFilter value;
  final ValueChanged<TaskFilter>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final filter in TaskFilter.values)
          FilterChip(
            label: Text(_label(filter)),
            selected: value == filter,
            onSelected: onChanged == null ? null : (_) => onChanged!(filter),
          ),
      ],
    );
  }

  String _label(TaskFilter filter) {
    return switch (filter) {
      TaskFilter.all => 'All',
      TaskFilter.open => 'Open',
      TaskFilter.completed => 'Completed',
    };
  }
}
