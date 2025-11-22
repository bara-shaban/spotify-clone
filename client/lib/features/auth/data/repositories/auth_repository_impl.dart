import 'dart:developer' show log;
import 'dart:io';
import 'package:client/core/resources/data_state.dart';
import 'package:client/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:client/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:client/features/auth/domain/entities/auth_result.dart';
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
  Future<DataSuccess<AuthResult>> signUp({
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
      final user = User(
        id: signupResponse.user.id,
        email: signupResponse.user.email,
        name: signupResponse.user.name,
      );
      await _localDataSource.cacheUser(user);
      log('User signed up and cached: ${user.email}');
      await _localDataSource.cacheAccessToken(signupResponse.accessToken);
      log('Access token cached.');
      await _localDataSource.cacheRefreshToken(signupResponse.refreshToken);
      log('Refresh token cached.');

      return DataSuccess(
        AuthResult(
          user: user,
          accessToken: signupResponse.accessToken,
          refreshToken: signupResponse.refreshToken,
        ),
      );
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
  Future<bool> cacheRefreshToken(String refreshToken) async {
    try {
      _localDataSource.cacheRefreshToken(refreshToken);
      log('Refresh token cached successfully.');
      return true;
    } catch (e) {
      log('Error caching refresh token: $e');
      return false;
    }
  }

  @override
  Future<bool> isCachedRefreshTokenValid() async {
    try {
      final refreshToken = await getCachedRefreshToken();
      if (refreshToken == null) {
        throw NoRefreshTokenFailure();
      }
      await _remoteDataSource.isRefreshTokenValid(
        refreshToken: refreshToken,
      );
      log('Cached refresh token is valid.');
      return true;
    } on InvalidRefreshTokenFailure catch (e) {
      log('Cached refresh token is invalid: $e');
      rethrow;
    } catch (e, st) {
      log('Error validating cached refresh token: $e\n$st');
      rethrow;
    }
  }
}
