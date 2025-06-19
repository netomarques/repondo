import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:repondo/features/auth/presentation/notifiers/email_auth_notifier/sign_up_email_notifier.dart';
import 'package:repondo/features/auth/presentation/widgets/exports.dart';

class SignUpPage extends ConsumerStatefulWidget {
  static SignUpPage builder(BuildContext context, GoRouterState state) =>
      const SignUpPage();

  const SignUpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final SignUpEmailNotifier notifier;

  @override
  void initState() {
    super.initState();
    notifier = ref.read(signUpEmailNotifierProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpEmailNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              SignUpForm(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
                state: state,
                onSubmit: _submit,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    await notifier.signUpWithEmail(email: email, password: password);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
