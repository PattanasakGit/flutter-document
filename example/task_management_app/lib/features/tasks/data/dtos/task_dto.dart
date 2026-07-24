import 'package:ai_first_flutter_starter/core/errors/app_exception.dart';

final class TaskDto {
  const TaskDto({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.createdAt,
  });

  factory TaskDto.fromJson(Object? value) {
    final json = _objectMap(value, location: 'task');
    final id = _requiredString(json, 'id');
    final title = _requiredString(json, 'title');
    final description = switch (json['description']) {
      null => '',
      final String value => value,
      _ => throw const SchemaAppException(
        message: 'Task description must be a string.',
      ),
    };
    final completed = json['completed'];
    if (completed is! bool) {
      throw const SchemaAppException(
        message: 'Task completed must be a boolean.',
      );
    }
    final createdAtRaw = _requiredString(json, 'created_at');
    final createdAt = DateTime.tryParse(createdAtRaw);
    if (createdAt == null) {
      throw const SchemaAppException(
        message: 'Task created_at must be an ISO-8601 timestamp.',
      );
    }
    return TaskDto(
      id: id,
      title: title,
      description: description,
      completed: completed,
      createdAt: createdAt,
    );
  }

  factory TaskDto.fromEnvelope(Object? payload) {
    final root = _objectMap(payload, location: 'task response');
    return TaskDto.fromJson(root['data']);
  }

  final String id;
  final String title;
  final String description;
  final bool completed;
  final DateTime createdAt;

  static List<TaskDto> decodeList(Object? payload) {
    final root = _objectMap(payload, location: 'task list response');
    final data = root['data'];
    if (data is! List<Object?>) {
      throw const SchemaAppException(
        message: 'Task list response data must be an array.',
      );
    }
    return data.map(TaskDto.fromJson).toList(growable: false);
  }
}

Map<String, Object?> _objectMap(
  Object? value, {
  required String location,
}) {
  if (value is! Map<String, Object?>) {
    throw SchemaAppException(message: '$location must be a JSON object.');
  }
  return value;
}

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty) {
    throw SchemaAppException(message: 'Task $key must be a non-empty string.');
  }
  return value;
}
