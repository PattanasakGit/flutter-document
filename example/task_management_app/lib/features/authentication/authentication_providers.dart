import 'package:ai_first_flutter_starter/core/errors/error_mapper.dart';
import 'package:ai_first_flutter_starter/core/logging/app_logger.dart';
import 'package:ai_first_flutter_starter/core/storage/storage_provider.dart';
import 'package:ai_first_flutter_starter/features/authentication/application/use_cases/login_use_case.dart';
import 'package:ai_first_flutter_starter/features/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:ai_first_flutter_starter/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:ai_first_flutter_starter/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationRemoteDatasourceProvider =
    Provider<AuthenticationRemoteDatasource>(
      (ref) => const FakeAuthenticationRemoteDatasource(),
    );

final authenticationRepositoryProvider = Provider<AuthenticationRepository>(
  (ref) => AuthenticationRepositoryImpl(
    remoteDatasource: ref.watch(authenticationRemoteDatasourceProvider),
    secureStorage: ref.watch(secureStorageProvider),
    errorMapper: const ErrorMapper(),
    logger: ref.watch(appLoggerProvider),
  ),
);

final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.watch(authenticationRepositoryProvider)),
);
