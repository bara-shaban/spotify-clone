import 'package:client/app/di/di.dart';
import 'package:client/app/theme/theme.dart';
import 'package:client/features/auth/signup/ui/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The root widget of the application.
class App extends ConsumerWidget {
  /// Creates a [App].
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Spotify Clone',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
      darkTheme: AppTheme.darkThemeMode,
      themeMode: ThemeMode.dark,
      home: const SignUpPage(),
    );
  }
}
