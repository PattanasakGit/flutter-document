import 'dart:async';
import 'dart:collection';

import 'package:ai_first_flutter_starter/core/errors/failure.dart';
import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/entities/task_filter.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/repositories/task_repository.dart';
import 'package:ai_first_flutter_starter/features/tasks/presentation/controllers/task_list_controller.dart';
import 'package:ai_first_flutter_starter/features/tasks/presentation/states/task_list_state.dart';
import 'package:ai_first_flutter_starter/features/tasks/tasks_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _FakeTaskRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _FakeTaskRepository();
    container = ProviderContainer(
      overrides: [
        taskRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('loads repository tasks when the controller starts', () async {
    repository.tasks = [_task(id: 'one'), _task(id: 'two')];

    final subscription = container.listen(
      taskListControllerProvider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    await _flushMicrotasks();

    final state = container.read(taskListControllerProvider);
    expect(state, isA<TaskListReady>());
    expect((state as TaskListReady).tasks, repository.tasks);
    expect(repository.getTasksCallCount, 1);
  });

  test('exposes a fatal load failure as failed state', () async {
    repository.getTasksResult = const FailureResult(
      NetworkFailure(userMessage: 'Offline.'),
    );

    container.listen(taskListControllerProvider, (_, _) {});
    await _flushMicrotasks();

    final state = container.read(taskListControllerProvider);
    expect(state, isA<TaskListFailed>());
    expect((state as TaskListFailed).failure, isA<NetworkFailure>());
  });

  test('changes filter as derived state without reloading', () async {
    repository.tasks = [
      _task(id: 'open'),
      _task(id: 'done', isCompleted: true),
    ];
    container.listen(taskListControllerProvider, (_, _) {});
    await _flushMicrotasks();

    container
        .read(taskListControllerProvider.notifier)
        .setFilter(TaskFilter.completed);

    final state = container.read(taskListControllerProvider) as TaskListReady;
    expect(state.filter, TaskFilter.completed);
    expect(state.visibleTasks.map((task) => task.id), ['done']);
    expect(repository.getTasksCallCount, 1);
  });

  test('creates a task and appends it to the ready snapshot', () async {
    repository
      ..tasks = [_task(id: 'one')]
      ..createResult = Success(_task(id: 'created'));
    container.listen(taskListControllerProvider, (_, _) {});
    await _flushMicrotasks();

    await container
        .read(taskListControllerProvider.notifier)
        .create(title: 'Created', description: '');

    final state = container.read(taskListControllerProvider) as TaskListReady;
    expect(state.tasks.map((task) => task.id), ['one', 'created']);
    expect(state.isMutating, isFalse);
  });

  test('guards a duplicate toggle while a mutation is running', () async {
    repository
      ..tasks = [_task(id: 'one')]
      ..toggleCompleter = Completer<Result<Task>>();
    container.listen(taskListControllerProvider, (_, _) {});
    await _flushMicrotasks();
    final controller = container.read(taskListControllerProvider.notifier);

    final first = controller.toggle('one');
    final second = controller.toggle('one');
    expect(repository.toggleCallCount, 1);
    repository.toggleCompleter!.complete(
      Success(_task(id: 'one', isCompleted: true)),
    );
    await Future.wait([first, second]);

    final state = container.read(taskListControllerProvider) as TaskListReady;
    expect(state.tasks.single.isCompleted, isTrue);
  });

  test('ignores filter changes while a mutation is running', () async {
    repository
      ..tasks = [_task(id: 'one')]
      ..toggleCompleter = Completer<Result<Task>>();
    container.listen(taskListControllerProvider, (_, _) {});
    await _flushMicrotasks();
    final controller = container.read(taskListControllerProvider.notifier);

    final mutation = controller.toggle('one');
    controller.setFilter(TaskFilter.completed);
    expect(
      (container.read(taskListControllerProvider) as TaskListReady).filter,
      TaskFilter.all,
    );
    repository.toggleCompleter!.complete(
      Success(_task(id: 'one', isCompleted: true)),
    );
    await mutation;

    final state = container.read(taskListControllerProvider) as TaskListReady;
    expect(state.filter, TaskFilter.all);
  });

  test('ignores reload while a mutation is running', () async {
    repository
      ..tasks = [_task(id: 'one')]
      ..toggleCompleter = Completer<Result<Task>>();
    container.listen(taskListControllerProvider, (_, _) {});
    await _flushMicrotasks();
    final controller = container.read(taskListControllerProvider.notifier);

    final mutation = controller.toggle('one');
    await controller.load();
    expect(repository.getTasksCallCount, 1);
    repository.toggleCompleter!.complete(
      Success(_task(id: 'one', isCompleted: true)),
    );
    await mutation;

    final state = container.read(taskListControllerProvider) as TaskListReady;
    expect(state.tasks.single.isCompleted, isTrue);
  });

  test('keeps the newest result when loads overlap', () async {
    repository.tasks = [_task(id: 'initial')];
    container.listen(taskListControllerProvider, (_, _) {});
    await _flushMicrotasks();
    final controller = container.read(taskListControllerProvider.notifier);
    final first = Completer<Result<List<Task>>>();
    final second = Completer<Result<List<Task>>>();
    repository.getTasksCompleters
      ..add(first)
      ..add(second);

    final firstLoad = controller.load();
    final secondLoad = controller.load();
    second.complete(Success([_task(id: 'newest')]));
    await secondLoad;
    first.complete(Success([_task(id: 'stale')]));
    await firstLoad;

    final state = container.read(taskListControllerProvider) as TaskListReady;
    expect(state.tasks.single.id, 'newest');
  });

  test('preserves ready content when a mutation fails', () async {
    repository
      ..tasks = [_task(id: 'one')]
      ..createResult = const FailureResult(
        ValidationFailure(userMessage: 'Title is invalid.'),
      );
    container.listen(taskListControllerProvider, (_, _) {});
    await _flushMicrotasks();

    await container
        .read(taskListControllerProvider.notifier)
        .create(title: '', description: '');

    final state = container.read(taskListControllerProvider) as TaskListReady;
    expect(state.tasks.single.id, 'one');
    expect(state.actionError, 'Title is invalid.');
    expect(state.isMutating, isFalse);
  });

  test('updates and deletes the matching task in the ready snapshot', () async {
    repository.tasks = [_task(id: 'one'), _task(id: 'two')];
    container.listen(taskListControllerProvider, (_, _) {});
    await _flushMicrotasks();
    final controller = container.read(taskListControllerProvider.notifier);
    final edited =
        (_task(id: 'one').updateContent(
                  title: 'Edited task',
                )
                as Success<Task>)
            .data;

    await controller.update(edited);
    await controller.delete('two');

    final state = container.read(taskListControllerProvider) as TaskListReady;
    expect(state.tasks.single.id, 'one');
    expect(state.tasks.single.title, 'Edited task');
    expect(repository.updateCallCount, 1);
    expect(repository.deleteCallCount, 1);
  });
}

Future<void> _flushMicrotasks() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

Task _task({
  required String id,
  bool isCompleted = false,
}) {
  return (Task.restore(
            id: id,
            title: 'Task $id',
            description: '',
            isCompleted: isCompleted,
            createdAt: DateTime.utc(2026, 7, 24),
          )
          as Success<Task>)
      .data;
}

final class _FakeTaskRepository implements TaskRepository {
  List<Task> tasks = [];
  Result<Task>? createResult;
  Result<List<Task>>? getTasksResult;
  Completer<Result<Task>>? toggleCompleter;
  final Queue<Completer<Result<List<Task>>>> getTasksCompleters = Queue();
  int getTasksCallCount = 0;
  int toggleCallCount = 0;
  int updateCallCount = 0;
  int deleteCallCount = 0;

  @override
  Future<Result<Task>> create({
    required String title,
    required String description,
  }) async {
    return createResult ?? Success(_task(id: 'created'));
  }

  @override
  Future<Result<void>> delete(String id) async {
    deleteCallCount += 1;
    return const Success(null);
  }

  @override
  Future<Result<List<Task>>> getTasks() async {
    getTasksCallCount += 1;
    if (getTasksCompleters.isNotEmpty) {
      return getTasksCompleters.removeFirst().future;
    }
    return getTasksResult ?? Success(tasks);
  }

  @override
  Future<Result<Task>> toggle(String id) {
    toggleCallCount += 1;
    return toggleCompleter?.future ??
        Future.value(Success(_task(id: id, isCompleted: true)));
  }

  @override
  Future<Result<Task>> update(Task task) async {
    updateCallCount += 1;
    return Success(task);
  }
}
