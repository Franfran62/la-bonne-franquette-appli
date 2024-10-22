import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecuredStorage {
  final storage = const FlutterSecureStorage();

  Future<void> writeSecrets(String secretKey, String secretValue) async {
    await storage.write(key: secretKey, value: secretValue);
  }

  Future<String?> readSecret(String secretKey) async {
    String? secretValue = await storage.read(key: secretKey);
    return secretValue;
  }
}