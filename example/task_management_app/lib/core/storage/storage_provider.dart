import 'package:ai_first_flutter_starter/core/storage/secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<SecureStorage>(
  (ref) => const FlutterSecureStorageAdapter(FlutterSecureStorage()),
);
