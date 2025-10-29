import 'package:client/features/auth/data/dots/user_dot/user_dto.dart';

/// An abstract class representing the remote data source for authentication.
abstract class AuthRemoteDataSource {
  /// Signs up a new user.
  Future<UserDto> signup({
    required String name,
    required String email,
    required String password,
  });

  /// Logs in an existing user.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });
}
