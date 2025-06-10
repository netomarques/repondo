import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:repondo/features/auth/presentation/notifiers/email_auth_notifier.dart';
import 'package:repondo/features/auth/presentation/widgets/auth_form.dart';

class LoginPage extends ConsumerStatefulWidget {
  static LoginPage builder(BuildContext context, GoRouterState state) =>
      const LoginPage();

  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final EmailAuthNotifier notifier;

  @override
  void initState() {
    super.initState();
    notifier = ref.read(emailAuthNotifierProvider.notifier);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    await notifier.signInWithEmail(email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(emailAuthNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              AuthForm(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
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

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
