final class CreateTaskRequestDto {
  const CreateTaskRequestDto({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  Map<String, Object?> toJson() => {
    'title': title,
    'description': description,
  };
}

final class TaskUpdateRequestDto {
  const TaskUpdateRequestDto({
    required this.title,
    required this.description,
    required this.completed,
  });

  final String title;
  final String description;
  final bool completed;

  Map<String, Object?> toJson() => {
    'title': title,
    'description': description,
    'completed': completed,
  };
}
