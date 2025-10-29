import 'package:client/core/utils/result.dart';
import 'package:client/features/auth/domain/entities/user.dart';

/// Repository for authentication-related operations.
// ignore: one_member_abstracts
abstract class AuthRepository {
  /// Signs up a new user.
  Future<User> signUp({
    required String name,
    required String email,
    required String password,
  });
}
