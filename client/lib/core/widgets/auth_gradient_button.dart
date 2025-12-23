import 'package:client/app/theme/app_pallete.dart';
import 'package:client/features/auth/presentation/state/auth_notifier/auth_notifier.dart';
import 'package:client/features/auth/presentation/state/auth_state/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A custom gradient button widget
class CustomGradientButton extends ConsumerWidget {
  /// Creates a [CustomGradientButton].
  const CustomGradientButton({
    required this.onPressed,
    this.text,
    super.key,
  });

  /// The text to display on the button.
  final String? text;

  /// The callback to be invoked when the button is pressed.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authProvider);
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppPalette.gradient1, AppPalette.gradient2],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: state.maybeWhen(
        loading: () => const SizedBox(
          height: 55,
          width: 395,
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
        orElse: () => ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(395, 55),
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 30,
            ),
            textStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: AppPalette.transparentColor,
            shadowColor: AppPalette.transparentColor,
          ),
          child: Text(
            text ?? '',
          ),
        ),
      ),
    );
  }
}
