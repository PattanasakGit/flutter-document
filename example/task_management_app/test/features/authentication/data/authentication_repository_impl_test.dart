import 'package:ai_first_flutter_starter/core/errors/app_exception.dart';
import 'package:ai_first_flutter_starter/core/errors/error_mapper.dart';
import 'package:ai_first_flutter_starter/core/errors/failure.dart';
import 'package:ai_first_flutter_starter/core/logging/app_logger.dart';
import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/core/storage/secure_storage.dart';
import 'package:ai_first_flutter_starter/core/storage/secure_storage_keys.dart';
import 'package:ai_first_flutter_starter/features/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:ai_first_flutter_starter/features/authentication/data/dtos/login_request_dto.dart';
import 'package:ai_first_flutter_starter/features/authentication/data/dtos/login_response_dto.dart';
import 'package:ai_first_flutter_starter/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:ai_first_flutter_starter/features/authentication/domain/entities/authenticated_user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_data.dart';

final class _StubAuthenticationRemoteDatasource
    implements AuthenticationRemoteDatasource {
  LoginResponseDto? response;
  Exception? error;
  LoginRequestDto? receivedRequest;

  @override
  Future<LoginResponseDto> login(LoginRequestDto request) async {
    receivedRequest = request;
    final currentError = error;
    if (currentError != null) {
      throw currentError;
    }
    return response!;
  }
}

final class _InMemorySecureStorage implements SecureStorage {
  final values = <String, String>{};

  @override
  Future<void> delete({required String key}) async {
    values.remove(key);
  }

  @override
  Future<String?> read({required String key}) async => values[key];

  @override
  Future<void> write({
    required String key,
    required String value,
  }) async {
    values[key] = value;
  }
}

final class _RecordingAppLogger implements AppLogger {
  final errors = <Object?>[];

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    errors.add(error);
  }

  @override
  void info(String message) {}
}

void main() {
  late _StubAuthenticationRemoteDatasource datasource;
  late _InMemorySecureStorage storage;
  late _RecordingAppLogger logger;
  late AuthenticationRepositoryImpl repository;

  setUp(() {
    datasource = _StubAuthenticationRemoteDatasource();
    storage = _InMemorySecureStorage();
    logger = _RecordingAppLogger();
    repository = AuthenticationRepositoryImpl(
      remoteDatasource: datasource,
      secureStorage: storage,
      errorMapper: const ErrorMapper(),
      logger: logger,
    );
  });

  test('maps the DTO, stores the token, and returns a user', () async {
    datasource.response = LoginResponseDto.fromJson(
      TestData.loginResponseJson,
    );

    final result = await repository.login(
      email: TestData.email,
      password: TestData.password,
    );

    expect(result, isA<Success<AuthenticatedUser>>());
    expect(
      storage.values[SecureStorageKeys.accessToken],
      TestData.token,
    );
    expect(datasource.receivedRequest?.email, TestData.email);
  });

  test('maps an external exception to a domain failure', () async {
    datasource.error = const UnauthorizedAppException(
      message: 'backend diagnostic',
    );

    final result = await repository.login(
      email: TestData.email,
      password: TestData.password,
    );

    expect(
      (result as FailureResult<AuthenticatedUser>).failure,
      isA<UnauthorizedFailure>(),
    );
    expect(logger.errors, hasLength(1));
  });

  test('deletes the stored token on logout', () async {
    storage.values[SecureStorageKeys.accessToken] = TestData.token;

    final result = await repository.logout();

    expect(result, isA<Success<void>>());
    expect(storage.values, isNot(contains(SecureStorageKeys.accessToken)));
  });
}
