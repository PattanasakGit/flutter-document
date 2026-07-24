import 'package:ai_first_flutter_starter/core/network/interceptors/authentication_interceptor.dart';
import 'package:ai_first_flutter_starter/core/storage/secure_storage.dart';
import 'package:ai_first_flutter_starter/core/storage/secure_storage_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSecureStorage extends Mock implements SecureStorage {}

class _MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

void main() {
  late SecureStorage storage;
  late RequestInterceptorHandler handler;
  late AuthenticationInterceptor interceptor;

  setUpAll(() {
    registerFallbackValue(RequestOptions());
  });

  setUp(() {
    storage = _MockSecureStorage();
    handler = _MockRequestInterceptorHandler();
    interceptor = AuthenticationInterceptor(storage);
  });

  test('adds a bearer token when secure storage contains one', () async {
    when(
      () => storage.read(key: SecureStorageKeys.accessToken),
    ).thenAnswer((_) async => 'token');
    final options = RequestOptions(path: '/profile');

    await interceptor.onRequest(options, handler);

    expect(options.headers['Authorization'], 'Bearer token');
    verify(() => handler.next(options)).called(1);
  });

  test('continues without authorization when no token is stored', () async {
    when(
      () => storage.read(key: SecureStorageKeys.accessToken),
    ).thenAnswer((_) async => null);
    final options = RequestOptions(path: '/profile');

    await interceptor.onRequest(options, handler);

    expect(options.headers, isNot(contains('Authorization')));
    verify(() => handler.next(options)).called(1);
  });
}
