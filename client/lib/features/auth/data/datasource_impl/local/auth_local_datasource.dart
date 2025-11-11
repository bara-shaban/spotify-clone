import 'dart:convert';
import 'dart:developer' as devtools show log;
import 'package:client/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:client/features/auth/domain/entities/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

const int _currentcachedVersion = 1;

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this.box);

  final Box box;

  @override
  Future<void> cacheUser(User user) async {
    try {
      final wrapped = {
        'version': _currentcachedVersion,
        'data': user.toJson(),
      };
      await box.put('cached_user', wrapped);
      devtools.log('cached user (v$_currentcachedVersion)');
    } catch (e) {
      devtools.log('Error cashing user: $e');
    }
  }

  @override
  Future<User?> getCachedUser() async {
    try {
      final raw = box.get('cached_user');
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
        devtools.log(
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
      devtools.log('Loaded cached user(v$version)');
      return user;
    } catch (e) {
      devtools.log('Error reading cached user:$e');
      return null;
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await box.delete('cached_user');
      devtools.log('Cleared cached user');
    } catch (e) {
      devtools.log('Error clearing cached user: $e');
    }
  }

  @override
  Future<void> cacheAccessToken(String token) {
    // TODO: implement cacheAccessToken
    throw UnimplementedError();
  }

  @override
  Future<void> clearAccessToken() {
    // TODO: implement clearAccessToken
    throw UnimplementedError();
  }

  @override
  Future<String?> getCachedAccessToken() {
    // TODO: implement clearcachedUser
    throw UnimplementedError();
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
  Future<void> cacheRefreshToken(String token) {
    // TODO: implement cacheRefreshToken
    throw UnimplementedError();
  }

  @override
  Future<void> clearAllAuthData() {
    // TODO: implement clearAllAuthData
    throw UnimplementedError();
  }

  @override
  Future<void> clearRefreshToken() {
    // TODO: implement clearRefreshToken
    throw UnimplementedError();
  }

  @override
  Future<String?> getCachedRefreshToken() {
    // TODO: implement getcachedRefreshToken
    throw UnimplementedError();
  }

  @override
  Future<void> migrateCacheIfNeeded() {
    // TODO: implement getcachedRefreshToken
    throw UnimplementedError();
  }
}
