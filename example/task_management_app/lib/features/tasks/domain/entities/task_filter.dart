import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task.dart';

enum TaskFilter {
  all,
  open,
  completed;

  bool matches(Task task) {
    return switch (this) {
      TaskFilter.all => true,
      TaskFilter.open => !task.isCompleted,
      TaskFilter.completed => task.isCompleted,
    };
  }
}
