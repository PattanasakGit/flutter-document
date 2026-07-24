import 'package:ai_first_flutter_starter/app/config/app_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.development(),
);
