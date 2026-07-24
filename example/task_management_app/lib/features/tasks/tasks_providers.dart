import 'package:ai_first_flutter_starter/core/errors/error_mapper.dart';
import 'package:ai_first_flutter_starter/core/logging/app_logger.dart';
import 'package:ai_first_flutter_starter/core/network/network_provider.dart';
import 'package:ai_first_flutter_starter/features/tasks/application/task_use_cases.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/datasources/in_memory_task_datasource.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/repositories/remote_task_repository.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/task_seed.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/repositories/task_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskLocalDatasourceProvider = Provider<TaskLocalDatasource>(
  (ref) => InMemoryTaskDatasource(seed: TaskSeed.defaults),
);

final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => TaskRepositoryImpl(
    datasource: ref.watch(taskLocalDatasourceProvider),
    idGenerator: () => 'task-${DateTime.now().microsecondsSinceEpoch}',
    clock: DateTime.now,
    errorMapper: const ErrorMapper(),
    logger: ref.watch(appLoggerProvider),
  ),
);

final taskRemoteDatasourceProvider = Provider<TaskRemoteDatasource>(
  (ref) => DioTaskRemoteDatasource(ref.watch(apiClientProvider)),
);

final remoteTaskRepositoryProvider = Provider<TaskRepository>(
  (ref) => RemoteTaskRepository(
    datasource: ref.watch(taskRemoteDatasourceProvider),
    errorMapper: const ErrorMapper(),
    logger: ref.watch(appLoggerProvider),
  ),
);

final getTasksProvider = Provider<GetTasks>(
  (ref) => GetTasks(ref.watch(taskRepositoryProvider)),
);

final createTaskProvider = Provider<CreateTask>(
  (ref) => CreateTask(ref.watch(taskRepositoryProvider)),
);

final updateTaskProvider = Provider<UpdateTask>(
  (ref) => UpdateTask(ref.watch(taskRepositoryProvider)),
);

final toggleTaskProvider = Provider<ToggleTask>(
  (ref) => ToggleTask(ref.watch(taskRepositoryProvider)),
);

final deleteTaskProvider = Provider<DeleteTask>(
  (ref) => DeleteTask(ref.watch(taskRepositoryProvider)),
);
