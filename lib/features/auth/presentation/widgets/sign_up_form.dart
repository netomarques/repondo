import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/presentation/validators/auth_validators.dart';
import 'package:repondo/features/auth/presentation/widgets/exports.dart';

class SignUpForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final AsyncValue<UserAuth?> state;
  final VoidCallback onSubmit;

  const SignUpForm(
      {super.key,
      required this.formKey,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController,
      required this.state,
      required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          AuthTextFormField(
            key: SignUpFormKeys.emailField,
            controller: emailController,
            labelText: 'Email',
            textInputType: TextInputType.emailAddress,
            validator: validateEmail,
          ),
          const SizedBox(height: 16),
          AuthTextFormField(
            key: SignUpFormKeys.passwordField,
            controller: passwordController,
            labelText: 'Senha',
            textInputType: TextInputType.visiblePassword,
            validator: validatePassword,
            obscureText: true,
          ),
          const SizedBox(height: 16),
          AuthTextFormField(
            key: SignUpFormKeys.confirmPasswordField,
            controller: confirmPasswordController,
            labelText: 'Confirme a senha',
            textInputType: TextInputType.visiblePassword,
            validator: (value) =>
                validatePasswordConfirmation(value, passwordController.text),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          AuthErrorMessage(key: SignUpFormKeys.errorMessage, state: state),
          state.isLoading
              ? const Center(
                  key: SignUpFormKeys.loadingIndicator,
                  child: CircularProgressIndicator())
              : ButtonForm(
                  key: SignUpFormKeys.submitButton,
                  onSubmit: onSubmit,
                  textAction: 'Cadastar'),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
