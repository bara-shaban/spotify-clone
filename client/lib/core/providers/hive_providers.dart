import 'dart:convert';
import 'dart:math';
import 'package:client/core/config/env.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _secure = FlutterSecureStorage();
const _hiveKeyName = 'hive_encryption_key';

/// Synchronous provider that exposes the already-opened auth Hive box
///
/// This provider is intended to be **overridden** in the 'main' with the real
/// opened box value:
///   envProvider.overrideWithValue(env),
///   authBoxProvider.overrideWithValue(authBox),
///
/// The default implementation throws
/// so you can catch missing override issues early.
final authBoxProvider = Provider<Box<dynamic>>(
  (ref) {
    throw UnimplementedError(
      'authBoxProvider was read before being overridden with a real Hive box.'
      'Ensure that you override it in main.dart before using it.',
    );
  },
);

Future<List<int>> _getOrCreateEncryptionKey() async {
  final existingKey = await _secure.read(key: _hiveKeyName);
  if (existingKey != null && existingKey.isNotEmpty) {
    try {
      final decodedKey = base64Decode(existingKey);
      if (decodedKey.length == 32) {
        return decodedKey;
      }
    }
    ///
    // ignore: avoid_catches_without_on_clauses
    catch (e) {
      // If decoding fails, we will generate a new key below
    }
  }
  final rand = Random.secure();
  final key = List<int>.generate(32, (_) => rand.nextInt(256));
  await _secure.write(
    key: _hiveKeyName,
    value: base64Encode(key),
  );
  return key;
}

/// Initialize Hive (if needed), ensure the encryption key exists in the secure
/// storage, and open the encrypted auth box, Returns the opened [Box].
///
/// Call this from app bootstrap (main) before running the app and use
/// the returned box to override the [authBoxProvider].
Future<Box<dynamic>> initAuthHiveBox(String authBoxNameForFlavor) async {
  try {
    final key = await _getOrCreateEncryptionKey();
    final cipher = HiveAesCipher(key);

    final box = await Hive.openBox<dynamic>(
      authBoxNameForFlavor,
      encryptionCipher: cipher,
    );
    return box;
  } catch (e) {
    rethrow;
  }
}

/// Destroys the auth Hive box by clearing its contents and closing it.
/// If the box is not open, it attempts to open it temporarily to clear it.
/// Also removes the encryption key from secure storage if specified.
Future<void> destroyAuthData({bool removeKeyFromSecureStorage = true}) async {
  if (Hive.isBoxOpen(_hiveKeyName)) {
    final box = Hive.box<dynamic>(_hiveKeyName);
    await box.clear();
    await box.close();
  } else {
    try {
      final key = await _getOrCreateEncryptionKey();
      final cipher = HiveAesCipher(key);
      final box = await Hive.openBox<dynamic>(
        _hiveKeyName,
        encryptionCipher: cipher,
      );
      await box.clear();
      await box.close();
    } catch (_) {
      // If we can't open the box, we can ignore the error
    }
    if (removeKeyFromSecureStorage) {
      await _secure.delete(key: _hiveKeyName);
    }
  }
}
