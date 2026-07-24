import 'package:ai_first_flutter_starter/app/app.dart';
import 'package:ai_first_flutter_starter/app/bootstrap/app_initializer.dart';
import 'package:ai_first_flutter_starter/app/config/app_config.dart';
import 'package:ai_first_flutter_starter/app/config/environment_provider.dart';
import 'package:ai_first_flutter_starter/core/logging/app_logger.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer(
    overrides: [
      appConfigProvider.overrideWithValue(config),
      appLoggerProvider.overrideWithValue(appLoggerFor(config)),
    ],
  );
  await AppInitializer(container.read(appLoggerProvider)).initialize();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}

AppLogger appLoggerFor(AppConfig config) {
  if (config.enableLogging) {
    return const DeveloperAppLogger();
  }
  return const NoOpAppLogger();
}
