import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const flutterSecureStorage = FlutterSecureStorage();
  static Future<void> saveAccessToken(String token) async {
     await flutterSecureStorage.write(key:"access_token", value: token);
  }

  static Future<String?> getAccessToken() async {
    return await flutterSecureStorage.read(key: "access_token");
  }

  static Future<void> saveRefreshToken(String token) async {
    await flutterSecureStorage.write(key: "refresh_token", value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await flutterSecureStorage.read(key: "refresh_token");
  }
  static Future<void> deleteTokens() async {
    await flutterSecureStorage.delete(key: "access_token");
    await flutterSecureStorage.delete(key: "refresh_token");
  }
}
