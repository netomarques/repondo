import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:repondo/features/auth/presentation/notifiers/email_auth_notifier/sign_in_email_notifier.dart';
import 'package:repondo/features/auth/presentation/router/auth_route_locations.dart';
import 'package:repondo/features/auth/presentation/widgets/exports.dart';

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
  late final SignInEmailNotifier notifier;

  @override
  void initState() {
    super.initState();
    notifier = ref.read(signInEmailNotifierProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInEmailNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              LoginForm(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                state: state,
                button: ButtonForm(onSubmit: _submit, textAction: 'Login'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => state.isLoading == false
                    ? context.push(AuthRouteLocations.signUp)
                    : null,
                child: const Text("Ainda não tem uma conta? Cadastre-se"),
              ),
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

    await notifier.signInWithEmail(email: email, password: password);
  }

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
