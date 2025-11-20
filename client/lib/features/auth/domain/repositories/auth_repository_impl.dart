import 'dart:developer' show log;
import 'dart:io';
import 'package:client/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:client/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:client/features/auth/domain/entities/user.dart';
import 'package:client/features/auth/domain/failures/auth_failure.dart';
import 'package:client/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of [AuthRepository] that uses remote and local data sources.
class AuthRepositoryImpl implements AuthRepository {
  /// Creates an instance of [AuthRepositoryImpl].
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  /// Signs up a new user.
  @override
  Future<User> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final cachedUser = await _localDataSource.getCachedUser();
      if (cachedUser != null) {
        log('Using cached user for signup: ${cachedUser.email}');
        return cachedUser;
      }

      final signupResponse = await _remoteDataSource.signup(
        name: name,
        email: email,
        password: password,
      );
      final user = User(
        id: signupResponse.id,
        email: signupResponse.email,
        name: signupResponse.name,
      );
      await _localDataSource.cacheUser(user);
      log('User signed up and cached: ${user.email}');

      return user;
    } on SocketException catch (e, stackTrace) {
      log('Network error during signup: $e', stackTrace: stackTrace);
      throw NetworkFailure();
    } catch (e, stackTrace) {
      log('Error during signup: $e', stackTrace: stackTrace);
      throw AuthFailure('Signup failed: $e', stackTrace);
    }
  }

  @override
  Future<User?> getCachedUser() async {
    final cachedUser = await _localDataSource.getCachedUser();
    if (cachedUser != null) {
      log('Retrieved cached user: ${cachedUser.email}');
      return cachedUser;
    }
    log('No cached user found.');
    return null;
  }

  @override
  Future<String?> getCachedRefreshToken() {
    final cachedToken = _localDataSource.getCachedRefreshToken();
    return cachedToken;
  }

  @override
  Future<bool> isRefreshTokenValid() async {
    final refreshToken = await getCachedRefreshToken();
    if (refreshToken == null) {
      log('No cached refresh token found.');
      return false;
    }
    // Here you would typically validate the token's expiry or signature.
    // For simplicity, we'll assume it's valid if it exists.
    log('Cached refresh token is valid.');
    return true;
  }
}
