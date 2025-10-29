import 'package:client/core/network/api_client.dart';
import 'package:client/core/network/api_response.dart';
import 'package:client/features/auth/domain/entities/user.dart';
import 'package:dio/dio.dart';

/// An implementation of [ApiClient] using the Dio package.
class DioApiClient implements ApiClient {
  DioApiClient(this._dio);

  /// Creates an instance of [DioApiClient].
  final Dio _dio;

  @override
  Future<Response<dynamic>> get({required String path}) {
    throw UnimplementedError();
  }

  @override
  Future<T> post<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
      );
      if (response.data is Map<String, dynamic>) {
        return fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('some error happend here ${response.runtimeType}');
      }
    } on DioException catch (e) {
      print('Dio error: ${e.type}');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      rethrow;
    }
  }

  @override
  Future<Response<User?>> put({required String path, dynamic data}) {
    return _dio.put(path, data: data);
  }

  @override
  Future<Response<User?>> patch({required String path, dynamic data}) {
    return _dio.patch(path, data: data);
  }

  @override
  Future<Response<User>> delete({required String path}) {
    return _dio.delete(path);
  }

  @override
  void setAuthToken(String token) {
    _storeToken(token);
  }

  @override
  void clearAuthToken() {
    _clearStoredToken();
  }

  @override
  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  String? _getStoredToken() {
    return null;
  }

  void _storeToken(String token) {}

  void _clearStoredToken() {}

  void _handleTokenExpiration() {}
}
