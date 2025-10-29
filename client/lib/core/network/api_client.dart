import 'package:dio/dio.dart';

/// A client for making API requests.
abstract class ApiClient {
  /// Makes a GET request to the specified [path].
  Future<Response<dynamic>> get({required String path});

  /// Makes a POST requist to the specfied [path] with given [data]
  Future<T> post<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic> data,
    Map<String, dynamic>? headers,
  });

  /// Makes a PUT request to the specified [path] with the given [data].
  Future<Response<dynamic>> put({required String path, dynamic data});

  /// Makes a PATCH request to the specified [path] with the given [data].
  Future<Response<dynamic>> patch({required String path, dynamic data});

  /// Makes a DELETE request to the specified [path].
  Future<Response<dynamic>> delete({required String path});

  /// Sets the authentication token for subsequent requests.
  void setAuthToken(String token);

  /// Clears the authentication token.
  void clearAuthToken();

  /// Sets the base URL for the API client.
  void setBaseUrl(String baseUrl);
}
