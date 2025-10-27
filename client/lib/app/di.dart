import 'package:client/core/network/api_client.dart';
import 'package:client/core/network/dio_api_client.dart';
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
