import 'package:client/core/utils/result.dart';
import 'package:client/features/auth/domain/entities/user.dart';
import 'package:client/features/auth/domain/repositories/auth_repository.dart';
import 'package:client/features/auth/domain/value_objects/email.dart';
import 'package:client/features/auth/domain/value_objects/name.dart';
import 'package:client/features/auth/domain/value_objects/password.dart';

/// Use case for signing up a user in (pure domain logic)
class SignupUsecase {
  /// Creates a [SignupUsecase].
  const SignupUsecase(this._repo);
  final AuthRepository _repo;

  /// Signs up a new user.
  /// Returns a [Result] containing the signed-up [User] or an error.
  Future<User> call({
    required String name,
    required String email,
    required String password,
  }) async {
    final nameVo = Name(name);
    final emailVo = Email(email);
    final passwordVo = Password(password);
    final user = _repo.signUp(
      name: nameVo.getOrCrash(),
      email: emailVo.getOrCrash(),
      password: passwordVo.getOrCrash(),
    );
    return user;
  }
}
