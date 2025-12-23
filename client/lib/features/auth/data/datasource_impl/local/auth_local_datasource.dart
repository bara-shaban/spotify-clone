import 'dart:convert';
import 'dart:developer' show log;
import 'package:client/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:client/features/auth/domain/entities/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

const int _currentcachedVersion = 1;

/// Implementation of [AuthLocalDataSource] using Hive for local storage.
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  /// Constructs an instance of [AuthLocalDataSourceImpl] with the given [box].
  AuthLocalDataSourceImpl(
    this.box,
  );
  static const String _kCachedUserKey = 'cached_user';
  static const String _kAccessTokenKey = 'access_token';
  static const String _kRefreshTokenKey = 'refresh_token';
  static const String _kUserLoggedInKey = 'user_logged_in';

  /// The Hive box used for local storage.
  final Box<dynamic> box;

  @override
  Future<void> cacheUser(User user) async {
    try {
      final wrapped = {
        'version': _currentcachedVersion,
        'data': user.toJson(),
      };
      await box.put(_kCachedUserKey, wrapped);
      log('cached user (v$_currentcachedVersion)');
    } catch (e) {
      log('Error cashing user: $e');
      rethrow;
    }
  }

  @override
  Future<User?> getCachedUser() async {
    try {
      final raw = box.get(_kCachedUserKey);
      if (raw == null) return null;

      Map<String, dynamic> wrapper;
      if (raw is Map) {
        wrapper = Map<String, dynamic>.from(raw);
      } else if (raw is String) {
        final decoded = jsonDecode(raw);
        if (decoded is! Map) return null;
        wrapper = Map<String, dynamic>.from(decoded);
      } else {
        return null;
      }

      final version = wrapper['version'];
      if (version is! int || version != _currentcachedVersion) {
        log(
          'cached version mismatch: $version != $_currentcachedVersion',
        );
        await clearCachedUser();
        return null;
      }
      final data = wrapper['data'];
      if (data is! Map) return null;

      final user = User.fromJson(
        Map<String, dynamic>.from(data),
      );
      log('Loaded cached user(v$version)');
      return user;
    } catch (e) {
      log('Error reading cached user:$e');
      return null;
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await box.delete('cached_user');
      log('Cleared cached user');
    } catch (e) {
      log('Error clearing cached user: $e');
    }
  }

  @override
  Future<void> cacheAccessToken(String token) async {
    try {
      await box.put('access_token', token);
    } catch (e) {
      log('Error caching access token: $e');
    }
  }

  @override
  Future<void> clearAccessToken() async {
    try {
      await box.delete('access_token');
    } catch (e) {
      log('Error clearing access token: $e');
      rethrow;
    }
  }

  @override
  Future<String?> getCachedAccessToken() async {
    try {
      final token = box.get(_kAccessTokenKey) as String?;
      return token;
    } catch (e) {
      log('Error getting cached access token: $e');
      return null;
    }
  }

  @override
  Future<bool> isUserLoggedIn() {
    // TODO: implement isUserLoggedIn
    throw UnimplementedError();
  }

  @override
  Future<void> setUserLoggedIn(bool isLoggedIn) {
    // TODO: implement setUserLoggedIn
    throw UnimplementedError();
  }

  @override
  Future<void> cacheRefreshToken(String token) async {
    try {
      await box.put('refresh_token', token);
    } catch (e) {
      log('Error caching refresh token: $e');
    }
  }

  @override
  Future<String?> getCachedRefreshToken() async {
    try {
      final token = box.get(_kRefreshTokenKey) as String?;
      return token;
    } catch (e) {
      log('Error getting cached refresh token: $e');
      return null;
    }
  }

  @override
  Future<void> clearRefreshToken() async {
    try {
      await box.delete('refresh_token');
    } catch (e) {
      log('Error clearing refresh token: $e');
    }
  }

  @override
  Future<void> clearAllAuthData() {
    try {
      log('Clearing all auth data from local cache');
      return box.clear();
    } catch (e) {
      log('Error clearing all auth data: $e');
      rethrow;
    }
  }

  @override
  Future<void> migrateCacheIfNeeded() {
    // TODO: implement getcachedRefreshToken
    throw UnimplementedError();
  }
}
