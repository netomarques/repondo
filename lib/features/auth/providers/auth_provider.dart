import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/providers/sign_in_usecase_provider.dart';
import 'package:repondo/features/auth/providers/sign_out_usecase_provider.dart';
import 'package:repondo/features/auth/presentation/notifiers/auth_notifier.dart';

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final signInUseCase = ref.read(signInUseCaseProvider);
  final signOutUseCase = ref.read(singOutUseCaseProvider);
  return AuthNotifier(
      signInUseCase: signInUseCase, signOutUseCase: signOutUseCase);
});
