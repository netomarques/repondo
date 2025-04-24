import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/presentation/notifiers/google_auth_notifier.dart';
import 'package:repondo/features/auth/presentation/pages/home_page.dart';
import 'package:repondo/features/auth/presentation/pages/login_page.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final googleAuth = ref.watch(googleAuthNotifierProvider);

    return googleAuth.when(
      data: (_) => const HomePage(),
      error: (_, __) => const LoginPage(),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
