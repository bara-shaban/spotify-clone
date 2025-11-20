import 'dart:convert';
import 'package:client/core/errors/app_error.dart';
import 'package:client/core/network/api_client.dart';
import 'package:client/features/auth/domain/entities/user.dart';
import 'package:dio/dio.dart';

/// An implementation of [ApiClient] using the Dio package.
class DioApiClient implements ApiClient {
  /// Creates an instance of [DioApiClient].
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
      final response = await _dio.post<dynamic>(
        path,
        data: data == null ? null : jsonEncode(data),
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
          // Keep validateStatus here too in case Options overrides it
          validateStatus: (status) =>
              status != null && status >= 100 && status < 600,
        ),
      );

      // 3.1 Normalize body to Map<String, dynamic>
      final body = _normalizeToJsonMap(response.data['user']);

      // 3.2 Check HTTP status family
      final status = response.statusCode ?? 0;

      if (status >= 200 && status < 300) {
        // Accept 200..299 (FastAPI often returns 201 Created)
        return fromJson(body);
      }

      // 3.3 Build an error message with server payload if any
      final serverMsg = _extractServerMessage(body);
      final msg = serverMsg ?? 'Request failed ($status) while POST $path';

      throw ApiClientException(
        message: msg,
        statusCode: status,
        data: body.isEmpty ? null : body,
      );
    } on DioException catch (e) {
      // Network / timeout / cancel / bad cert etc.
      final status = e.response?.statusCode;
      final body = _normalizeToJsonMap(e.response?.data);

      final reason = switch (e.type) {
        DioExceptionType.connectionTimeout => 'Connection timeout',
        DioExceptionType.sendTimeout => 'Send timeout',
        DioExceptionType.receiveTimeout => 'Receive timeout',
        DioExceptionType.badCertificate => 'Bad TLS certificate',
        DioExceptionType.badResponse =>
          'Bad response (${status ?? 'no status'})',
        DioExceptionType.cancel => 'Request cancelled',
        DioExceptionType.connectionError => 'Network error',
        DioExceptionType.unknown => 'Unexpected network error',
      };

      final serverMsg = _extractServerMessage(body);
      final msg = serverMsg ?? reason;

      throw ApiClientException(
        message: msg,
        statusCode: status,
        data: body.isEmpty ? null : body,
        original: e,
      );
    } catch (e) {
      // Any non-Dio throw
      throw ApiClientException(message: 'Unexpected error: $e');
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

  /// Accepts Map, List, String(JSON), or null and returns a JSON Map.
  /// If it can't parse to a Map, returns {}.
  Map<String, dynamic> _normalizeToJsonMap(dynamic data) {
    if (data == null) return <String, dynamic>{};

    try {
      if (data is Map<String, dynamic>) {
        return data;
      }
      if (data is Map) {
        // Map<dynamic, dynamic> -> Map<String, dynamic>
        return data.map((k, v) => MapEntry(k.toString(), v));
      }
      if (data is String && data.isNotEmpty) {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) {
          return decoded.map((k, v) => MapEntry(k.toString(), v));
        }
      }
    } catch (_) {
      // fall through to empty map
    }
    return <String, dynamic>{};
  }

  /// Pulls a readable message from common API error shapes:
  /// { "detail": "..."}  (FastAPI default)
  /// { "message": "..." }
  /// { "error": "..." }
  /// { "errors": [ { "msg": "..."} ] } (pydantic)
  String? _extractServerMessage(Map<String, dynamic> body) {
    if (body.isEmpty) return null;

    final detail = body['detail'];
    if (detail is String && detail.isNotEmpty) return detail;

    final message = body['message'];
    if (message is String && message.isNotEmpty) return message;

    final error = body['error'];
    if (error is String && error.isNotEmpty) return error;

    final errors = body['errors'];
    if (errors is List && errors.isNotEmpty) {
      final first = errors.first;
      if (first is Map && first['msg'] is String) return first['msg'] as String;
    }
    return null;
  }
}
