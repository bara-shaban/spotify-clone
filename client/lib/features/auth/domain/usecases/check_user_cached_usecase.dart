import 'package:client/features/auth/domain/repositories/auth_repository.dart';

/// Usecase to check if a user is cached (logged in).
class CheckUserSessionUseCase {
  /// Creates an instance of [CheckUserSessionUseCase].
  CheckUserSessionUseCase({required AuthRepository repository})
    : _repository = repository;

  final AuthRepository _repository;

  /// Checks if a user is cached (logged in).
  Future<bool> call() async {
    final user = await _repository.getCachedUser();
    if (user == null) return false;

    final refreshToken = await _repository.getCachedRefreshToken();
    return true;
    // TODO: Uncomment when token validation is implemented
  }
}
