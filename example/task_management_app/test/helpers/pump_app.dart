import 'package:ai_first_flutter_starter/app/app.dart';
import 'package:ai_first_flutter_starter/app/config/app_config.dart';
import 'package:ai_first_flutter_starter/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:ai_first_flutter_starter/features/tasks/domain/repositories/task_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'provider_overrides.dart';

extension PumpApp on WidgetTester {
  Future<ProviderContainer> pumpStarterApp({
    required AuthenticationRepository authenticationRepository,
    TaskRepository? taskRepository,
    AppConfig? appConfig,
  }) async {
    final container = createTestContainer(
      authenticationRepository: authenticationRepository,
      taskRepository: taskRepository,
      appConfig: appConfig,
    );
    addTearDown(container.dispose);

    await pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const App(),
      ),
    );
    await pump();
    return container;
  }
}
