import 'package:client/core/utils/result.dart';
import 'package:client/features/auth/domain/entities/user.dart';

/// Repository for authentication-related operations.
abstract class AuthRepository {
  /// Signs up a new user.
  Future<User> signUp({
    required String name,
    required String email,
    required String password,
  });

  /// Retrieves the cached user if available.
  Future<User?> getCachedUser();

  /// Retrieves the cached refresh token if available.
  Future<String?> getCachedRefreshToken();

  /// Checks if the cached refresh token is valid.
  Future<bool> isRefreshTokenValid();
}
