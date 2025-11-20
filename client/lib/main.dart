import 'dart:async';
import 'dart:developer' show log;
import 'package:client/app/app.dart';
import 'package:client/core/config/env.dart';
import 'package:client/core/persistence/init_boxes.dart';
import 'package:client/core/providers/env_provider.dart';
import 'package:client/core/providers/hive_providers.dart';
import 'package:client/core/providers/logger_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pedantic/pedantic.dart' show unawaited;

/// Registers Hive adapters.
/* Future<void> _registerHiveAdapters() async {
  // TODO: Register Hive adapters here if any
} */

/// One-time, synchronous-first initialization of persistence.
/// - Initializes Hive (idempotent).
///
Future<InitBoxes> _initPersistence({
  required AppEnvironment env,
}) async {
  final authBoxNameForFlavor = getAuthBoxNameForFlavor(env.flavor);
  try {
    if (env.verboseLogging) {
      log('DEV: Initializing Hive...', name: 'main');
    }
    await Hive.initFlutter();
    //await _registerHiveAdapters();
    log(
      'Opening Hive box: $authBoxNameForFlavor',
      name: 'main',
    );

    final box = await Hive.openBox<dynamic>(authBoxNameForFlavor);
    if (env.verboseLogging) {
      log(
        'DEV: Auth box opened: $authBoxNameForFlavor',
        name: 'main',
      );
    }
    //await openFuture.timeout(_kStartupTimeout);
    log('Persistence initialization completed.', name: 'main');

    return InitBoxes(authBox: box);

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
  catch (e, st) {
    log(
      'Error initializing persistence: $e',
      name: 'main',
      error: e,
      stackTrace: st,
    );
    rethrow;
  }
}

Future<void> _postStartupTasks({required AppEnvironment env}) async {
  // TODO: Implement any post-startup tasks here
  log('Running post-startup tasks...', name: 'main');
}

Future<InitBoxes> _initializeApp({
  required AppEnvironment env,
}) async {
  if (!kReleaseMode) {
    if (env.verboseLogging) {
      log(
        'DEV: Initializing app in ${env.flavor} flavor',
        name: 'main',
      );
    }
  }
  final boxes = await _initPersistence(env: env);
  return boxes;
}

Future<void> main() async {
  final env = makeEnvironmentFromDefines();
  final startupLogger = DevLogger(verbose: env.verboseLogging);
  BindingBase.debugZoneErrorsAreFatal = kDebugMode;

  // In production, we'll use the timeout to fail fast if something is wrong
  // await _initializeApp(env: env).timeout(_kStartupTimeout);

  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (FlutterErrorDetails details) {
        if (kDebugMode) {
          FlutterError.dumpErrorToConsole(details);
        }
        startupLogger.log(
          'Flutter framework Error: ${details.exception}',
          name: 'FlutterError',
          error: details.exception,
          stackTrace: details.stack,
        );
        // It's eather
        // FlutterError.presentError(details);
        // or
        // FlutterError.dumpErrorToConsole(details);
        // to display errors
        // FlutterError.presentError(details);
      };
      try {
        final boxes = await _initializeApp(env: env);
        final authBox = boxes.authBox;
        runApp(
          ProviderScope(
            overrides: [
              envProvider.overrideWithValue(env),
              authBoxProvider.overrideWithValue(
                authBox,
              ),
              loggerProvider.overrideWithValue(
                startupLogger,
              ),
            ],
            child: const App(
              key: ValueKey('app_root_dev'),
            ),
          ),
        );
      }
      /// Needs to be catch-all to prevent app from not starting
      // ignore: avoid_catches_without_on_clauses
      catch (e, st) {
        startupLogger.log(
          'Failed to initialize: $e',
          name: 'main',
          error: e,
          stackTrace: st,
        );
        /* runApp(
          ProviderScope(overrides: [
            envProvider.overrideWithValue(env),
            ],
            child: ErrorApp(error: e)),
        ); */
      }

      unawaited(_postStartupTasks(env: env));
      if (env.verboseLogging) {
        startupLogger.log('DEV: App started successfully', name: 'main');
        if (!kReleaseMode) {
          startupLogger.log(
            'DEV: Running in ${env.flavor} flavor',
            name: 'main',
          );
        }
      }
    },
    (error, stack) {
      log(
        'DEV Uncaught async error in runZonedGuarded $error',
        error: error,
        stackTrace: stack,
        name: 'main',
      );
    },
  );
}
