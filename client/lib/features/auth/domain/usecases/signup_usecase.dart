/* import 'package:client/core/utils/result.dart';
import 'package:client/features/auth/domain/entities/user.dart';
import 'package:client/features/auth/domain/repositories/auth_repository.dart';

/// Use case for signing up a user in (pure domain logic)
class SignupUsecase {
  /// Creates a [SignupUsecase].
  const SignupUsecase(this._repo);
  final AuthRepository _repo;

  /// Signs up a new user.
  /// Returns a [Result] containing the signed-up [User] or an error.
  Future<Result<User?>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    return _repo.signUp(
      name: name,
      email: email,
      password: password,
    );
  }
}
 */
