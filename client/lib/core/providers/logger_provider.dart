import 'dart:developer' as developer;

import 'package:client/core/providers/env_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AppLogger {
  void log(
    String message, {
    String name,
    Object? error,
    StackTrace? stackTrace,
  });
  void debug(
    String message, {
    String name,
  });
  void error(
    String message,
    Object? error,
    StackTrace? stackTrace,
  );
}

class DevLogger implements AppLogger {
  final bool verbose;
  DevLogger({required this.verbose});
  @override
  void log(
    String message, {
    String name = 'app',
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: name,
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void debug(String message, {String name = 'app'}) {
    if (verbose) {
      developer.log('DEBUG: $message', name: name);
    }
  }

  @override
  void error(String message, Object? error, StackTrace? stackTrace) {
    developer.log(
      'ERROR: $message',
      name: 'app',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

final loggerProvider = Provider<AppLogger>((ref) {
  final env = ref.watch(envProvider);

  return DevLogger(verbose: env.verboseLogging);
});
