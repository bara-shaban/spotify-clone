import 'package:client/core/network/api_client.dart';
import 'package:client/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:client/features/repositories/auth_remote_repository.dart';

/// Implementation of [AuthRemoteRepository] that interacts with a remote API.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// Creates an instance of [AuthRemoteDataSourceImpl].
  AuthRemoteDataSourceImpl(this._apiClient, this._baseUrl);

  final ApiClient _apiClient;
  final String _baseUrl;

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    throw Exception();
  }
}
