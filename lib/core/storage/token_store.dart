import 'secure_storage.dart';

class TokenStore {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';

  static Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    DateTime? expiry,
  }) async {
    await SecureStorage.write(_accessTokenKey, accessToken);

    if (refreshToken != null) {
      await SecureStorage.write(_refreshTokenKey, refreshToken);
    }

    if (expiry != null) {
      await SecureStorage.write(_tokenExpiryKey, expiry.toIso8601String());
    }
  }

  static Future<String?> get accessToken async {
    return await SecureStorage.read(_accessTokenKey);
  }

  static Future<String?> get refreshToken async {
    return await SecureStorage.read(_refreshTokenKey);
  }

  static Future<DateTime?> get tokenExpiry async {
    final expiryString = await SecureStorage.read(_tokenExpiryKey);
    if (expiryString != null) {
      try {
        return DateTime.parse(expiryString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static Future<bool> get hasValidToken async {
    final token = await accessToken;
    if (token == null) return false;

    final expiry = await tokenExpiry;
    if (expiry == null) return true; // No expiry means token is always valid

    return DateTime.now().isBefore(expiry);
  }

  static Future<void> clearTokens() async {
    await SecureStorage.delete(_accessTokenKey);
    await SecureStorage.delete(_refreshTokenKey);
    await SecureStorage.delete(_tokenExpiryKey);
  }

  static Future<void> clearAll() async {
    await SecureStorage.deleteAll();
  }
}
