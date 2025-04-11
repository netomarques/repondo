import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/providers/auth_provider.dart';
import 'package:repondo/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:repondo/features/auth/presentation/pages/home_page.dart';
import 'package:repondo/features/auth/presentation/pages/login_page.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return authState is Authenticated
        ? HomePage()
        : authState is AuthLoading
            ? CircularProgressIndicator()
            : LoginPage(); // Ou redirecionar pro login automático
  }
}
