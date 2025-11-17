/// The name of the Hive box for authentication data.
const String kAuthBoxName = 'auth_box';

/// The duration to wait for startup operations to complete.
const Duration kStartupTimeout = Duration(seconds: 10);

/// Whether to use mock implementations for services.
const bool kUseMocks = bool.fromEnvironment('USE_MOCKS', defaultValue: true);
