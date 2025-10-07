import 'package:client/core/theme/theme.dart';
import 'package:client/features/auth/signup/ui/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp].
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.darkThemeMode,
      home: const SignUpPage(),
    );
  }
}
