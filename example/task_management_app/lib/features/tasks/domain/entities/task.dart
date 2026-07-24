import 'package:ai_first_flutter_starter/core/errors/failure.dart';
import 'package:ai_first_flutter_starter/core/result/result.dart';

final class Task {
  const Task._({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
  });

  static Result<Task> restore({
    required String id,
    required String title,
    required String description,
    required bool isCompleted,
    required DateTime createdAt,
  }) {
    return _validated(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: createdAt,
    );
  }

  static const maxTitleLength = 120;
  static const maxDescriptionLength = 500;

  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;

  static Result<Task> create({
    required String id,
    required String title,
    required DateTime createdAt,
    String description = '',
  }) {
    return _validated(
      id: id,
      title: title,
      description: description,
      isCompleted: false,
      createdAt: createdAt,
    );
  }

  Result<Task> updateContent({
    required String title,
    String description = '',
  }) {
    return _validated(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: createdAt,
    );
  }

  Task toggle() {
    return Task._(
      id: id,
      title: title,
      description: description,
      isCompleted: !isCompleted,
      createdAt: createdAt,
    );
  }

  static Result<Task> _validated({
    required String id,
    required String title,
    required String description,
    required bool isCompleted,
    required DateTime createdAt,
  }) {
    final cleanId = id.trim();
    final cleanTitle = title.trim();
    final cleanDescription = description.trim();

    if (cleanId.isEmpty) {
      return const FailureResult(
        ValidationFailure(userMessage: 'Task identity must not be empty.'),
      );
    }
    if (cleanTitle.isEmpty) {
      return const FailureResult(
        ValidationFailure(userMessage: 'Enter a task title.'),
      );
    }
    if (cleanTitle.length > maxTitleLength) {
      return const FailureResult(
        ValidationFailure(
          userMessage: 'Task titles must be 120 characters or fewer.',
        ),
      );
    }
    if (cleanDescription.length > maxDescriptionLength) {
      return const FailureResult(
        ValidationFailure(
          userMessage: 'Descriptions must be 500 characters or fewer.',
        ),
      );
    }

    return Success(
      Task._(
        id: cleanId,
        title: cleanTitle,
        description: cleanDescription,
        isCompleted: isCompleted,
        createdAt: createdAt,
      ),
    );
  }
}
