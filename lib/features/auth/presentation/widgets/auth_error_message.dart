import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

class AuthErrorMessage extends StatelessWidget {
  final AsyncValue<UserAuth?> state;

  const AuthErrorMessage({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (!state.hasError) return const SizedBox.shrink();

    return Text(
      'Erro: ${_errorMessage()}',
      style: const TextStyle(color: Colors.red),
    );
  }

  _errorMessage() {
    final error = state.error;

    if (error is AuthException) return error.message;

    return 'Erro desconhecido';
  }
}
