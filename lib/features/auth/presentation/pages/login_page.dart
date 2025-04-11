import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/providers/auth_provider.dart';
import 'package:repondo/features/auth/presentation/notifiers/auth_notifier.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  ref.read(authNotifierProvider.notifier).login();
                },
                child: const Text('Entrar como Anônimo'),
              ),
      ),
    );
  }
}
