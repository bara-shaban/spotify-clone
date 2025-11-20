import 'package:client/features/auth/domain/entities/user.dart';

/// Local data source for authentication-related operations.
abstract class AuthLocalDataSource {
  // User management
  Future<void> cacheUser(User user);

  /// Retrieves the cached user if available.
  Future<User?> getCachedUser();

  Future<void> clearCachedUser();

  // Token management
  Future<void> cacheAccessToken(String token);
  Future<String?> getCachedAccessToken();
  Future<void> clearAccessToken();

  Future<void> cacheRefreshToken(String token);
  Future<String?> getCachedRefreshToken();
  Future<void> clearRefreshToken();

  // Session management
  Future<void> setUserLoggedIn(bool isLoggedIn);
  Future<bool> isUserLoggedIn();

  Future<void> clearAllAuthData();

  Future<void> migrateCacheIfNeeded();
}
