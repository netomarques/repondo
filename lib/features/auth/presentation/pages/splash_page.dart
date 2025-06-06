import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:repondo/features/auth/presentation/widgets/exports.dart';

class SplashPage extends ConsumerStatefulWidget {
  static SplashPage builder(BuildContext context, GoRouterState state) =>
      const SplashPage();

  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: SplashLogo()),
    );
  }
}
