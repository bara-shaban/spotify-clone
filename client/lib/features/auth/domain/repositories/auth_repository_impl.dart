import 'dart:io';

import 'package:client/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:client/features/auth/data/dots/user_dot/user_dto.dart';
import 'package:client/features/auth/domain/entities/user.dart';
import 'package:client/features/auth/domain/failures/auth_failure.dart';
import 'package:client/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;
  @override
  Future<User> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final signupResponse = await _remoteDataSource.signup(
        name: name,
        email: email,
        password: password,
      );
      return User(
        id: signupResponse.id,
        email: signupResponse.email,
        name: signupResponse.name,
      );
    } on SocketException catch (_, stackTrace) {
      throw NetworkFailure();
    } catch (e, stackTrace) {
      throw AuthFailure('Signup failed: $e', stackTrace);
    }
  }
}
