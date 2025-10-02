import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

/// A custom gradient button widget
class CustomGradientButton extends StatelessWidget {
  /// Creates a [CustomGradientButton].
  const CustomGradientButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  /// The text to display on the button.
  final String text;

  /// The callback to be invoked when the button is pressed.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppPalette.gradient1, AppPalette.gradient2],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(395, 55),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppPalette.transparentColor,
          shadowColor: AppPalette.transparentColor,
        ),
        child: Text(
          text,
        ),
      ),
    );
  }
}
