import 'package:ai_first_flutter_starter/core/storage/secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late FlutterSecureStorage plugin;
  late SecureStorage storage;

  setUp(() {
    plugin = _MockFlutterSecureStorage();
    storage = FlutterSecureStorageAdapter(plugin);
  });

  test('reads a value from the platform storage plugin', () async {
    when(() => plugin.read(key: 'access_token')).thenAnswer(
      (_) async => 'token',
    );

    final value = await storage.read(key: 'access_token');

    expect(value, 'token');
    verify(() => plugin.read(key: 'access_token')).called(1);
  });

  test('writes a value to the platform storage plugin', () async {
    when(
      () => plugin.write(key: 'access_token', value: 'token'),
    ).thenAnswer((_) async {});

    await storage.write(key: 'access_token', value: 'token');

    verify(
      () => plugin.write(key: 'access_token', value: 'token'),
    ).called(1);
  });

  test('deletes a value from the platform storage plugin', () async {
    when(() => plugin.delete(key: 'access_token')).thenAnswer((_) async {});

    await storage.delete(key: 'access_token');

    verify(() => plugin.delete(key: 'access_token')).called(1);
  });
}
