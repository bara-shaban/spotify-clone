import 'package:client/features/auth/domain/usecases/check_user_cached_usecase.dart';
import 'package:client/features/auth/domain/usecases/is_cached_refresh_token_valid_usecase.dart';
import 'package:client/features/auth/domain/usecases/signup_usecase.dart';

/// Aggregates all authentication-related usecases.
class AuthUsecases {
  /// Creates an instance of [AuthUsecases].
  AuthUsecases({
    required this.signup,
    required this.checkUserSession,
    required this.isCachedRefreshTokenValid,
  });

  /// Usecase for signing up a new user.x
  final SignupUsecase signup;

  /// Usecase for checking if a user is cached (logged in).
  final CheckUserSessionUseCase checkUserSession;

  /// Usecase to check if the cached refresh token is valid.
  final IsCachedRefreshTokenValidUsecase isCachedRefreshTokenValid;
}
