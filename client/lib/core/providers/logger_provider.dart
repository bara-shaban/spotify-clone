import 'dart:developer' as developer;
import 'package:client/core/providers/env_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstract logger interface for the application.
abstract class AppLogger {
  /// Logs a message with optional error and stack trace.
  void log(
    String message, {
    String name,
    Object? error,
    StackTrace? stackTrace,
  });

  /// Logs a debug message.
  void debug(
    String message, {
    String name,
  });

  /// Logs an error message with associated error and stack trace.
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
