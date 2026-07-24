import 'package:ai_first_flutter_starter/app/config/app_config.dart';
import 'package:ai_first_flutter_starter/app/config/environment_provider.dart';
import 'package:ai_first_flutter_starter/features/authentication/authentication_providers.dart';
import 'package:ai_first_flutter_starter/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/repositories/task_repository.dart';
import 'package:ai_first_flutter_starter/features/tasks/tasks_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

ProviderContainer createTestContainer({
  required AuthenticationRepository authenticationRepository,
  TaskRepository? taskRepository,
  AppConfig? appConfig,
}) {
  return ProviderContainer(
    overrides: [
      appConfigProvider.overrideWithValue(
        appConfig ??
            AppConfig.development(apiBaseUrl: 'https://test.example.invalid'),
      ),
      authenticationRepositoryProvider.overrideWithValue(
        authenticationRepository,
      ),
      if (taskRepository != null)
        taskRepositoryProvider.overrideWithValue(taskRepository),
    ],
  );
}
