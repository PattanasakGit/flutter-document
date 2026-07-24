import 'package:ai_first_flutter_starter/core/storage/secure_storage.dart';
import 'package:ai_first_flutter_starter/core/storage/secure_storage_keys.dart';
import 'package:dio/dio.dart';

final class AuthenticationInterceptor extends QueuedInterceptor {
  AuthenticationInterceptor(this._storage);

  final SecureStorage _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: SecureStorageKeys.accessToken);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
