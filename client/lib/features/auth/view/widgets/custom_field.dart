import 'package:flutter/material.dart';

/// Custom Text Form Field
class CustomField extends StatelessWidget {
  /// Constructor
  const CustomField({
    required this.hintText,
    super.key,
  });

  /// Hint Text
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(decoration: InputDecoration(hintText: hintText));
  }
}
