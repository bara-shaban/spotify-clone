import 'package:client/features/auth/data/dots/signup_response_dto/signup_response_dto.dart';

/// An abstract class representing the remote data source for authentication.
abstract class AuthRemoteDataSource {
  /// Signs up a new user.
  Future<SignupResponseDto> signup({
    required String name,
    required String email,
    required String password,
  });

  /// Logs in an existing user.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  /// Validates the given refresh token.
  Future<bool> isRefreshTokenValid({required String refreshToken});
}
