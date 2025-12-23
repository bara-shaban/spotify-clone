import 'package:client/features/auth/data/dots/signup_response_dto/signup_response_dto.dart';

/// An abstract class representing the remote data source for authentication.
abstract class AuthRemoteDataSource {
  /// Signs up a new user.
  Future<SignupLoginResponseDto> signup({
    required String name,
    required String email,
    required String password,
  });

  /// Logs in an existing user.
  Future<SignupLoginResponseDto> login({
    required String email,
    required String password,
  });

  /// Logs out the current user.
  Future<void> logout();

  /// Validates the given refresh token.
  Future<bool> isRefreshTokenValid({required String refreshToken});
}
