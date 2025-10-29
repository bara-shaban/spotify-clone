import 'package:client/core/network/api_client.dart';
import 'package:client/core/network/dio_api_client.dart';
import 'package:client/features/auth/data/datasource_impl/auth_remote_data_source_impl.dart';
import 'package:client/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:client/features/auth/domain/repositories/auth_repository.dart';
import 'package:client/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// low-level client
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );
  return dio;
});

final apiClientProvider = Provider<ApiClient>(
  (ref) {
    final dio = ref.read(dioProvider);
    return DioApiClient(dio);
  },
);

final AuthRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) {
    final apiClient = ref.watch(apiClientProvider);
    return AuthRemoteDataSourceImpl(apiClient, '');
  },
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) {
    final remoteDataSource = ref.watch(AuthRemoteDataSourceProvider);
    return AuthRepositoryImpl(remoteDataSource: remoteDataSource);
  },
);
