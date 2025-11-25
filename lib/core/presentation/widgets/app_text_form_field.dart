import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType textInputType;
  final String? Function(String?) validator;
  final bool obscureText;

  const AppTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.textInputType,
    required this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      keyboardType: textInputType,
      obscureText: obscureText,
      validator: validator,
    );
  }
}
