import 'package:flutter/material.dart';

/// Custom Text Form Field
class CustomField extends StatelessWidget {
  /// Constructor
  const CustomField({
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    super.key,
  });

  /// Hint Text
  final String hintText;

  /// Is Password ?
  final bool isPassword;

  /// Text Editing Controller
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      obscureText: isPassword,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }
}
