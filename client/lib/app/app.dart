import 'package:client/app/di/di.dart';
import 'package:client/app/router.dart';
import 'package:client/app/theme/theme.dart';
import 'package:client/core/providers/env_provider.dart';
import 'package:client/core/providers/hive_providers.dart';
import 'package:client/core/providers/logger_provider.dart';
import 'package:client/features/auth/signup/ui/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Root app widget.
/// - Reads environment & logger from providers.
/// - Host top-level [MaterialApp]. and writing for theme,localization,routing.
class App extends ConsumerWidget {
  /// Creates a [App].
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = ref.watch(envProvider);
    final logger = ref.watch(loggerProvider);
    final authBox = ref.read(authBoxProvider);

    final showDebugBanner = env.flavor != 'prod' && env.verboseLogging;
    return MaterialApp.router(
      title: 'Spotify Clone',
      debugShowCheckedModeBanner: showDebugBanner,
      theme: AppTheme.lightThemeMode,
      darkTheme: AppTheme.darkThemeMode,
      themeMode: ThemeMode.dark,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
