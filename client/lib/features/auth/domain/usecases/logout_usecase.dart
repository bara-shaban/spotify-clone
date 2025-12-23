import 'package:client/core/resources/data_state.dart';
import 'package:client/features/auth/domain/repositories/auth_repository.dart';

/// Usecase for logging out a user.
class LogoutUsecase {
  /// Creates a [LogoutUsecase].
  const LogoutUsecase(this._repository);
  final AuthRepository _repository;

  /// Logs out the current user.
  Future<DataSuccess<void>> call() async {
    try {
      await _repository.logout();
      return const DataSuccess(null);
    } catch (e) {
      rethrow;
    }
  }
}
