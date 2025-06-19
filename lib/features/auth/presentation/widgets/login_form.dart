import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/presentation/validators/auth_validators.dart';
import 'package:repondo/features/auth/presentation/widgets/exports.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final AsyncValue<UserAuth?> state;
  final ButtonForm button;

  const LoginForm(
      {super.key,
      required this.formKey,
      required this.emailController,
      required this.passwordController,
      required this.state,
      required this.button});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          AuthTextFormField(
            controller: emailController,
            labelText: 'Email',
            textInputType: TextInputType.emailAddress,
            validator: validateEmail,
          ),
          const SizedBox(height: 16),
          AuthTextFormField(
            controller: passwordController,
            labelText: 'Senha',
            textInputType: TextInputType.visiblePassword,
            validator: validatePassword,
            obscureText: true,
          ),
          const SizedBox(height: 24),
          AuthErrorMessage(state: state),
          state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : button,
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
