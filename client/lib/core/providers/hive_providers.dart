import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
