import 'package:ai_first_flutter_starter/features/tasks/data/datasources/task_local_datasource.dart';

final class InMemoryTaskDatasource implements TaskLocalDatasource {
  InMemoryTaskDatasource({
    List<TaskRecord> seed = const [],
  }) : _records = [...seed];

  final List<TaskRecord> _records;

  @override
  Future<List<TaskRecord>> readAll() async {
    return List.unmodifiable(_records);
  }

  @override
  Future<TaskRecord?> readById(String id) async {
    for (final record in _records) {
      if (record.id == id) return record;
    }
    return null;
  }

  @override
  Future<TaskRecord?> insert(TaskRecord record) async {
    final index = _records.indexWhere((item) => item.id == record.id);
    if (index != -1) return null;
    _records.add(record);
    return record;
  }

  @override
  Future<TaskRecord?> update(TaskRecord record) async {
    final index = _records.indexWhere((item) => item.id == record.id);
    if (index == -1) return null;
    _records[index] = record;
    return record;
  }

  @override
  Future<bool> delete(String id) async {
    final before = _records.length;
    _records.removeWhere((record) => record.id == id);
    return _records.length != before;
  }
}
