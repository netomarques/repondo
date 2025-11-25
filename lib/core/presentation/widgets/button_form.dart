import 'package:flutter/material.dart';

class ButtonForm extends StatelessWidget {
  final VoidCallback onSubmit;
  final String textAction;
  final bool isLoading;

  const ButtonForm({
    super.key,
    required this.onSubmit,
    required this.textAction,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onSubmit,
      child: Center(
          child: isLoading
              ? const CircularProgressIndicator(strokeWidth: 2)
              : Text(textAction)),
    );
  }
}
