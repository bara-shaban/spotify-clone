import 'dart:developer' as devtools show log;
import 'package:client/core/errors/app_error.dart';
import 'package:client/core/network/api_client.dart';
import 'package:client/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:client/features/auth/data/dots/refresh_token_validation_dto.dart';
import 'package:client/features/auth/data/dots/signup_response_dto/signup_response_dto.dart';
import 'package:client/features/auth/domain/failures/auth_failure.dart';

/// Implementation of [AuthRemoteDataSource] that uses an [ApiClient].
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// Creates an instance of [AuthRemoteDataSourceImpl].
  AuthRemoteDataSourceImpl(this._apiClient, {required String basePath})
    : _endpoint = basePath;

  final ApiClient _apiClient;
  final String _endpoint;

  @override
  Future<SignupLoginResponseDto> login({
    required String email,
    required String password,
  }) {
    try {
      final response = _apiClient.post(
        path: '$_endpoint/login',
        fromJson: SignupLoginResponseDto.fromJson,
        data: {'email': email, 'password': password},
      );
      return response;
    } catch (e, st) {
      devtools.log('AuthRemoteDataSourceImpl.login() error: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<SignupLoginResponseDto> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        path: '$_endpoint/signup',
        fromJson: SignupLoginResponseDto.fromJson,
        data: {'name': name, 'email': email, 'password': password},
      );

      return response;
    } catch (e, st) {
      devtools.log('AuthRemoteDataSourceImpl.signup() error: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _apiClient.post(
        path: '$_endpoint/logout',
        fromJson: (json) => json,
      );
      return true;
    } catch (e, st) {
      devtools.log('AuthRemoteDataSourceImpl.logout() error: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<bool> isRefreshTokenValid({required String refreshToken}) async {
    try {
      await _apiClient.post<RefreshTokenValidationDto>(
        path: '$_endpoint/refresh',
        fromJson: RefreshTokenValidationDto.fromJson,
        data: {'refresh_token': refreshToken},
      );
      return true;
    } on ApiClientException catch (e, st) {
      if (e.statusCode == 401) {
        throw InvalidRefreshTokenFailure();
      }
      devtools.log(
        'AuthRemoteDataSourceImpl.isRefreshTokenValid() API error: $e\n$st',
      );
      rethrow;
    } catch (e, st) {
      devtools.log(
        'AuthRemoteDataSourceImpl.isRefreshTokenValid() error: $e\n$st',
      );
      rethrow;
    }
  }
}
