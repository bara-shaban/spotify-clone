import 'package:client/core/network/api_client.dart';
import 'package:client/core/network/dio_api_client.dart';
import 'package:client/features/auth/data/datasource_impl/local/auth_local_datasource.dart';
import 'package:client/features/auth/data/datasource_impl/remote/auth_remote_data_source_impl.dart';
import 'package:client/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:client/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:client/features/auth/domain/repositories/auth_repository.dart';
import 'package:client/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:client/features/auth/domain/usecases/check_user_cached_usecase.dart';
import 'package:client/features/auth/domain/usecases/signup_usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String _baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://127.0.0.1:8000',
);

/// Dependency Injection setup using Riverpod
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      validateStatus: (status) =>
          status != null && status >= 100 && status < 600,
    ),
  );
  return dio;
});

/// API Client Provider
final apiClientProvider = Provider<ApiClient>(
  (ref) {
    final dio = ref.watch(dioProvider);
    return DioApiClient(dio);
  },
);

/// Auth Remote Data Source Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) {
    final apiClient = ref.watch(apiClientProvider);
    return AuthRemoteDataSourceImpl(apiClient, basePath: '/api/v1/auth');
  },
);

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>(
  (ref) {
    final box = Hive.box('auth_box');
    return AuthLocalDataSourceImpl(box);
  },
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) {
    final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
    final localDataSource = ref.watch(authLocalDataSourceProvider);
    return AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  },
);

final signupUsecaseProvider = Provider<SignupUsecase>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return SignupUsecase(authRepository);
  },
);

final checkUserSessionUseCaseProvider = Provider<CheckUserSessionUseCase>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return CheckUserSessionUseCase(repository: authRepository);
  },
);
