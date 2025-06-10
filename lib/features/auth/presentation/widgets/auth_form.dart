import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/presentation/widgets/auth_error_message.dart';

class AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final AsyncValue<UserAuth?> state;
  final VoidCallback onSubmit;

  const AuthForm(
      {super.key,
      required this.formKey,
      required this.emailController,
      required this.passwordController,
      required this.state,
      required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          _textFormField(
            controller: emailController,
            labelText: 'Email',
            textInputType: TextInputType.emailAddress,
            validator: _validatorEmail,
          ),
          const SizedBox(height: 16),
          _textFormField(
            controller: passwordController,
            labelText: 'Senha',
            textInputType: TextInputType.visiblePassword,
            validator: _validatorPassword,
            obscureText: true,
          ),
          const SizedBox(height: 24),
          AuthErrorMessage(state: state),
          state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: onSubmit,
                  child: const Text('Entrar'),
                ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  _textFormField({
    required TextEditingController controller,
    required String labelText,
    required TextInputType textInputType,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      keyboardType: textInputType,
      obscureText: obscureText,
      validator: validator,
    );
  }

  String? _validatorEmail(value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o email';
    }
    if (!value.contains('@')) {
      return 'Email inválido';
    }
    return null;
  }

  String? _validatorPassword(value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe a senha';
    }
    if (value.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }
}
