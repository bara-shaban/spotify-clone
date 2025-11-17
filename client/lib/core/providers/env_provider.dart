import 'package:client/core/config/env.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the current [AppEnvironment] to the entire app.
///
/// This will be overridden in main.dart with the real environment.
/// Created by 'makeEnvironmentFromDefines()' function.
///
/// Example:
///   final env = ref.watch(envProvider);
///   print(env.flavor); // 'dev', 'staging', or 'prod'
final envProvider = Provider<AppEnvironment>((ref) {
  return devEnv;
});
