import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:repondo/features/auth/presentation/notifiers/google_auth_notifier.dart';

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
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // final notifier = ref.read(authNotifierProvider.notifier);
    // await notifier.signInWithEmailAndPassword(email, password);
  }

  @override
  Widget build(BuildContext context) {
    // final authState = ref.watch(authNotifierProvider);
    // final isLoading = authState is AuthLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Informe o email' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Informe a senha' : null,
                ),
                const SizedBox(height: 24),
                // isLoading
                //     ? const CircularProgressIndicator()
                //     : ElevatedButton(
                //         onPressed: _submit,
                //         child: const Text('Entrar'),
                //       ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    ref
                        .read(googleAuthNotifierProvider.notifier)
                        .signInWithGoogle();
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Entrar com Google'),
                ),
                const SizedBox(height: 16),
                // TextButton(
                //     onPressed: () {
                //       ref.read(authNotifierProvider.notifier).login();
                //     },
                //     child: const Text('Entrar como Anônimo'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
