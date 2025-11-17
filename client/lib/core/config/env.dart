/// The name of the Hive box for authentication data.
const String kAuthBoxName = 'auth_box';

/// The duration to wait for startup operations to complete.
const Duration kStartupTimeout = Duration(seconds: 10);

/// Whether to use mock implementations for services.
const bool kUseMocks = bool.fromEnvironment('USE_MOCKS', defaultValue: true);

/// Represents the application runtime environment configuration.
/// - crash reporting behavior
/// - logging behavior
/// - API/backend flavor
/// - feature toggles (can be expanded)
///
/// Every environment (dev, staging, prod) is represented by
/// an instance of this class.
class AppEnvironment {
  /// Creates an [AppEnvironment].
  const AppEnvironment({
    required this.enableCrashReporting,
    required this.verboseLogging,
    required this.flavor,
  });

  /// Whether crash reporting (Sentry, Crashlytics) is enabled.
  final bool enableCrashReporting;

  /// Whether verbose logging is enabled.
  ///
  /// In dev: should be true
  /// In prod: usually false
  final bool verboseLogging;

  /// The flavor of the application.
  /// - dev
  /// - staging
  /// - prod
  final String flavor;
}

/// Default development environment
///
/// This is the environment used locally.
const AppEnvironment devEnv = AppEnvironment(
  enableCrashReporting: false,
  verboseLogging: true,
  flavor: 'dev',
);

/// Default staging environment
///
/// This is the environment used for QA testers and CI builds.
const AppEnvironment stagingEnv = AppEnvironment(
  enableCrashReporting: true,
  verboseLogging: true,
  flavor: 'staging',
);

/// Default production environment
///
/// Used when e.g. building release versions of the app.
const AppEnvironment prodEnv = AppEnvironment(
  enableCrashReporting: true,
  verboseLogging: false,
  flavor: 'prod',
);

/// Reads environment values from '--dart-define' flags
/// and constructs an [AppEnvironment] object.
///
/// Example:
/// flutter run --dart-define=FLAVOR=staging
///
/// If no flags are provided, defaults to [devEnv].
AppEnvironment makeEnvironmentFromDefines() {
  final flavor = String.fromEnvironment(
    'FLAVOR',
    defaultValue: devEnv.flavor,
  );
  final enableCrashReporting =
      String.fromEnvironment(
        'CRASH_REPORTING',
        defaultValue: '${devEnv.enableCrashReporting}',
      ) ==
      'true';
  final verboseLogging =
      String.fromEnvironment(
        'VERBOSE_LOGGING',
        defaultValue: '${devEnv.verboseLogging}',
      ) ==
      'true';
  // If only flavor is passed, other fleads follow flavor defaults
  switch (flavor) {
    case 'prod':
      return AppEnvironment(
        flavor: flavor,
        enableCrashReporting: enableCrashReporting,
        verboseLogging: verboseLogging,
      );
    case 'staging':
      return AppEnvironment(
        flavor: flavor,
        enableCrashReporting: enableCrashReporting,
        verboseLogging: verboseLogging,
      );
    case 'dev':
    default:
      return AppEnvironment(
        flavor: flavor,
        enableCrashReporting: enableCrashReporting,
        verboseLogging: verboseLogging,
      );
  }
}

/// Resolves the full Hive box name for current flavor.
///
/// Example:
///   getAuthBoxNameForFlavor('dev') => 'auth_box_dev'
String getAuthBoxNameForFlavor(String flavor) => '${kAuthBoxName}_$flavor';
