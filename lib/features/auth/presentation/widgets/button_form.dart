import 'package:flutter/material.dart';

class ButtonForm extends StatelessWidget {
  final VoidCallback onSubmit;
  final String textAction;

  const ButtonForm({
    super.key,
    required this.onSubmit,
    required this.textAction,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onSubmit,
      child: Text(textAction),
    );
  }
}
