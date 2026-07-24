final class TaskRecord {
  const TaskRecord({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.createdAtIso,
  });

  final String id;
  final String title;
  final String description;
  final bool completed;
  final String createdAtIso;
}

abstract interface class TaskLocalDatasource {
  Future<List<TaskRecord>> readAll();

  Future<TaskRecord?> readById(String id);

  Future<TaskRecord?> insert(TaskRecord record);

  Future<TaskRecord?> update(TaskRecord record);

  Future<bool> delete(String id);
}
