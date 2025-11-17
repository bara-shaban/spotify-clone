import 'dart:async';
import 'dart:developer' show log;
import 'package:client/app/app.dart';
import 'package:client/core/config/env.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pedantic/pedantic.dart' show unawaited;

/// The application environment configuration.
class AppEnvironment {
  /// Creates an [AppEnvironment].
  const AppEnvironment({
    required this.enableCrashReporting,
    required this.verboseLogging,
    required this.flavor,
  });

  /// Whether crash reporting is enabled.
  final bool enableCrashReporting;

  /// Whether verbose logging is enabled.
  final bool verboseLogging;

  /// The flavor of the application.
  final String flavor;
}

const AppEnvironment _devEnv = AppEnvironment(
  enableCrashReporting: false,
  verboseLogging: true,
  flavor: 'dev',
);

AppEnvironment _envFromDefines() {
  final flavor = String.fromEnvironment(
    'FLAVOR',
    defaultValue: _devEnv.flavor,
  );
  final enableCrashReporting =
      String.fromEnvironment(
        'CRASH_REPORTING',
        defaultValue: '${_devEnv.enableCrashReporting}',
      ) ==
      'true';
  final verboseLogging =
      String.fromEnvironment(
        'VERBOSE_LOGGING',
        defaultValue: '${_devEnv.verboseLogging}',
      ) ==
      'true';
  return AppEnvironment(
    enableCrashReporting: enableCrashReporting,
    verboseLogging: verboseLogging,
    flavor: flavor,
  );
}

/// Registers Hive adapters.
// ignore: unused_element
Future<void> _registerHiveAdapters() async {
  // TODO: Register Hive adapters here if any
}

Future<void> _initPersistence({required AppEnvironment env}) async {
  try {
    if (env.verboseLogging) {
      log('DEV: Initializing Hive...', name: 'main');
    }
    await Hive.initFlutter();
    //await _registerHiveAdapters();
    log(
      'Opening Hive box: ${kAuthBoxName}_${env.flavor}',
      name: 'main',
    );

    final isOpen = Hive.isBoxOpen('${kAuthBoxName}_${env.flavor}');
    if (!isOpen) {
      await Hive.openBox<dynamic>('${kAuthBoxName}_${env.flavor}');
      if (env.verboseLogging) {
        log(
          'DEV: Auth box opened: ${kAuthBoxName}_${env.flavor}',
          name: 'main',
        );
      }
    } else {
      if (env.verboseLogging) {
        log(
          'DEV: Auth box already open: ${kAuthBoxName}_${env.flavor}',
          name: 'main',
        );
      }
    }
    //await openFuture.timeout(_kStartupTimeout);
    log('Persistence initialization completed.', name: 'main');

    /* 
    WE USE THIS IN DEV MODE FOR FASTER HOT RELOADS UNLESS 
    OUR APP NEEDS THE BOX TO BE OPENED TO MAKE THE ROUTE
    
    final catchError = Hive.openBox<dynamic>(_kAuthBoxName)
        .then((box) {
          if (env.verboseLogging)
            devtools.log('DEV: Auth box opened: $_kAuthBoxName', name: 'main');
        })
        .catchError((e, st) {
          devtools.log('DEV: Failed to open auth box: $e', name: 'main');
        }); */
  } // Include timeout handling on production builds
  /* on TimeoutException catch (t, st) {
    devtools.log(
      'Timeout initializing persistence: $t',
      name: 'main',
      error: t,
      stackTrace: st,
    );
    
  }  */
  /// Generic catch block
  // ignore: avoid_catches_without_on_clauses
  catch (e, st) {
    log(
      'Error initializing persistence: $e',
      name: 'main',
      error: e,
      stackTrace: st,
    );
  }
}

Future<void> _postStartupTasks({required AppEnvironment env}) async {
  // TODO: Implement any post-startup tasks here
  log('Running post-startup tasks...', name: 'main');
}

Future<void> _initializeApp({required AppEnvironment env}) async {
  if (!kReleaseMode) {
    if (env.verboseLogging) {
      log(
        'DEV: Initializing app in ${env.flavor} flavor',
        name: 'main',
      );
    }
  }
  await _initPersistence(env: env);
  unawaited(_postStartupTasks(env: env));
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final env = _envFromDefines();
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
    log(
      'Flutter framework Error: ${details.exception}',
      name: 'FlutterError',
      error: details.exception,
      stackTrace: details.stack,
    );
    FlutterError.presentError(details);
  };
  await runZonedGuarded<Future<void>>(
    () async {
      // In production, we'll use the timeout to fail fast if something is wrong
      // await _initializeApp(env: env).timeout(_kStartupTimeout);
      await _initializeApp(env: env);
      runApp(
        ProviderScope(
          child: App(
            key: const ValueKey('app_root_dev'),
            env: env,
          ),
        ),
      );
      if (env.verboseLogging) {
        log('DEV: App started successfully', name: 'main');
        if (!kReleaseMode) {
          log(
            'DEV: Running in ${env.flavor} flavor',
            name: 'main',
          );
        }
      }
    },
    (error, stack) {
      log(
        'DEV Uncaught async error in runZonedGuardedL $error',
        error: error,
        stackTrace: stack,
        name: 'main',
      );
    },
  );
}
