import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class SecureStorage {
  Future<String?> read({required String key});

  Future<void> write({
    required String key,
    required String value,
  });

  Future<void> delete({required String key});
}

final class FlutterSecureStorageAdapter implements SecureStorage {
  const FlutterSecureStorageAdapter(this._plugin);

  final FlutterSecureStorage _plugin;

  @override
  Future<void> delete({required String key}) => _plugin.delete(key: key);

  @override
  Future<String?> read({required String key}) => _plugin.read(key: key);

  @override
  Future<void> write({
    required String key,
    required String value,
  }) => _plugin.write(key: key, value: value);
}
