import 'package:ai_first_flutter_starter/core/errors/error_mapper.dart';
import 'package:ai_first_flutter_starter/core/logging/app_logger.dart';
import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:ai_first_flutter_starter/core/storage/secure_storage.dart';
import 'package:ai_first_flutter_starter/core/storage/secure_storage_keys.dart';
import 'package:ai_first_flutter_starter/features/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:ai_first_flutter_starter/features/authentication/data/dtos/login_request_dto.dart';
import 'package:ai_first_flutter_starter/features/authentication/data/mappers/authentication_mapper.dart';
import 'package:ai_first_flutter_starter/features/authentication/domain/entities/authenticated_user.dart';
import 'package:ai_first_flutter_starter/features/authentication/domain/repositories/authentication_repository.dart';

final class AuthenticationRepositoryImpl implements AuthenticationRepository {
  factory AuthenticationRepositoryImpl({
    required AuthenticationRemoteDatasource remoteDatasource,
    required SecureStorage secureStorage,
    required ErrorMapper errorMapper,
    required AppLogger logger,
  }) {
    return AuthenticationRepositoryImpl._(
      remoteDatasource,
      secureStorage,
      errorMapper,
      logger,
    );
  }

  const AuthenticationRepositoryImpl._(
    this._remoteDatasource,
    this._secureStorage,
    this._errorMapper,
    this._logger,
  );

  final AuthenticationRemoteDatasource _remoteDatasource;
  final SecureStorage _secureStorage;
  final ErrorMapper _errorMapper;
  final AppLogger _logger;

  @override
  Future<Result<AuthenticatedUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDatasource.login(
        LoginRequestDto(email: email, password: password),
      );
      await _secureStorage.write(
        key: SecureStorageKeys.accessToken,
        value: response.accessToken,
      );
      return Success(response.toEntity());
    } on Object catch (error, stackTrace) {
      _logger.error(
        'Authentication login failed.',
        error: error,
        stackTrace: stackTrace,
      );
      return FailureResult(_errorMapper.mapException(error));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _secureStorage.delete(key: SecureStorageKeys.accessToken);
      return const Success(null);
    } on Object catch (error, stackTrace) {
      _logger.error(
        'Authentication logout failed.',
        error: error,
        stackTrace: stackTrace,
      );
      return FailureResult(_errorMapper.mapException(error));
    }
  }
}
