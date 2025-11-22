import 'package:client/features/auth/domain/repositories/auth_repository.dart';

/// Usecase to check if the cached refresh token is valid.
class IsCachedRefreshTokenValidUsecase {
  /// Creates an instance of [IsCachedRefreshTokenValidUsecase].
  IsCachedRefreshTokenValidUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  /// Checks if the cached refresh token is valid.
  Future<bool> call() async {
    return _authRepository.isCachedRefreshTokenValid();
  }
}
