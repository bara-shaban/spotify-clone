import 'package:client/features/auth/domain/entities/user.dart';

/// Local data source for authentication-related operations.
abstract class AuthLocalDataSource {
  // User management
  Future<void> cacheUser(User user);

  /// Retrieves the cached user if available.
  Future<User?> getCachedUser();

  Future<void> clearCachedUser();

  // Token management
  /// Caches the access token.
  Future<void> cacheAccessToken(String token);
  Future<String?> getCachedAccessToken();

  /// Clears the cached access token.
  Future<void> clearAccessToken();

  /// Caches the refresh token.
  Future<void> cacheRefreshToken(String token);
  Future<String?> getCachedRefreshToken();

  /// Clears the cached refresh token.
  Future<void> clearRefreshToken();

  // Session management
  Future<void> setUserLoggedIn(bool isLoggedIn);
  Future<bool> isUserLoggedIn();

  Future<void> clearAllAuthData();

  Future<void> migrateCacheIfNeeded();
}
