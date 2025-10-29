import 'package:client/app/theme/theme.dart';
import 'package:client/core/network/api_client.dart';
import 'package:client/core/network/dio_api_client.dart';
import 'package:client/features/auth/data/datasource_impl/auth_remote_data_source_impl.dart';
import 'package:client/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:client/features/auth/data/dots/user_dot/user_dto.dart';
import 'package:client/features/auth/domain/repositories/auth_repository.dart';
import 'package:client/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:client/features/auth/login/ui/login_view.dart';
import 'package:client/features/auth/signup/ui/signup_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );
  final apiClient = DioApiClient(_dio);
  final authDataSource = AuthRemoteDataSourceImpl(
    apiClient,
    '/auth/signup',
  );
  final authRepository = await AuthRepositoryImpl(
    remoteDataSource: authDataSource,
  );
  final response = authRepository.signUp(
    email: 'aa@gmial.com',
    password: 'braa',
    name: 'ba',
  );
  print(response);
  print(response.runtimeType);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp].
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.darkThemeMode,
      home: const LogInPage(),
    );
  }
}
