import 'dart:developer' as devtools show log;
import 'package:client/core/network/api_client.dart';
import 'package:client/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:client/features/auth/data/dots/user_dot/user_dto.dart';
import 'package:client/features/repositories/auth_remote_repository.dart';

/// Implementation of [AuthRemoteRepository] that interacts with a remote API.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// Creates an instance of [AuthRemoteDataSourceImpl].
  AuthRemoteDataSourceImpl(this._apiClient, {required String basePath})
    : _endpoint = basePath;

  final ApiClient _apiClient;
  final String _endpoint;

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<UserDto> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        path: '$_endpoint/signup',
        fromJson: UserDto.fromJson,
        data: {'name': name, 'email': email, 'password': password},
      );

      return response;
    } catch (e, st) {
      devtools.log('AuthRemoteDataSourceImpl.signup() error: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<bool> isRefreshTokenValid({required String token}) async {
    try {
      /* final response = await _apiClient.post<Map<String, dynamic>>(path: '$_endpoint/refresh-token/validate',
        ); */
      return true;
    } catch (e, st) {
      devtools.log(
        'AuthRemoteDataSourceImpl.isRefreshTokenValid() error: $e\n$st',
      );
      rethrow;
    }
  }
}
