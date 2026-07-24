import 'package:ai_first_flutter_starter/features/tasks/data/datasources/in_memory_task_datasource.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const first = TaskRecord(
    id: 'task-1',
    title: 'First',
    description: '',
    completed: false,
    createdAtIso: '2026-07-24T00:00:00.000Z',
  );

  test('readAll returns an unmodifiable snapshot', () async {
    final datasource = InMemoryTaskDatasource(seed: const [first]);

    final records = await datasource.readAll();

    expect(records, hasLength(1));
    expect(records.single.id, first.id);
    expect(records.single.title, first.title);
    expect(() => records.add(first), throwsUnsupportedError);
  });

  test('insert rejects a duplicate identity', () async {
    final datasource = InMemoryTaskDatasource(seed: const [first]);
    const duplicate = TaskRecord(
      id: 'task-1',
      title: 'Duplicate',
      description: '',
      completed: false,
      createdAtIso: '2026-07-24T00:00:00.000Z',
    );

    final result = await datasource.insert(duplicate);

    final records = await datasource.readAll();
    expect(result, isNull);
    expect(records, hasLength(1));
    expect(records.single.title, first.title);
  });

  test(
    'update replaces an existing record and rejects a missing one',
    () async {
      final datasource = InMemoryTaskDatasource(seed: const [first]);
      const replacement = TaskRecord(
        id: 'task-1',
        title: 'Updated',
        description: 'Changed',
        completed: true,
        createdAtIso: '2026-07-24T00:00:00.000Z',
      );
      const missing = TaskRecord(
        id: 'missing',
        title: 'Missing',
        description: '',
        completed: false,
        createdAtIso: '2026-07-24T00:00:00.000Z',
      );

      final updated = await datasource.update(replacement);
      final absent = await datasource.update(missing);

      final records = await datasource.readAll();
      expect(updated, replacement);
      expect(absent, isNull);
      expect(records, hasLength(1));
      expect(records.single.id, replacement.id);
      expect(records.single.title, replacement.title);
      expect(records.single.completed, isTrue);
    },
  );

  test('delete removes a record and reports whether it existed', () async {
    final datasource = InMemoryTaskDatasource(seed: const [first]);

    expect(await datasource.delete('task-1'), isTrue);
    expect(await datasource.delete('task-1'), isFalse);
    expect(await datasource.readAll(), isEmpty);
  });
}
