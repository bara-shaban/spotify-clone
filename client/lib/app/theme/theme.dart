import 'package:client/app/theme/app_pallete.dart';
import 'package:flutter/material.dart';

/// App theme data
class AppTheme {
  static OutlineInputBorder _border({Color? color}) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: color ?? AppPalette.borderColor,
      width: 3,
    ),
  );

  /// Dark theme data
  static final ThemeData darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPalette.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder: _border(),
      focusedBorder: _border(color: AppPalette.gradient2),
    ),
  );
}
