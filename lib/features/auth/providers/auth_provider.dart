import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:repondo/features/auth/providers/exports.dart';

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final signInUseCase = ref.read(signInUseCaseProvider);
  final signOutUseCase = ref.read(singOutUseCaseProvider);
  final signInWithEmailAndPasswortUseCase =
      ref.read(signInWithEmailAndPasswordProvider);
  final signInWithGoogleUseCase = ref.read(signInWithGoogleProvider);
  return AuthNotifier(
      signInUseCase: signInUseCase,
      signOutUseCase: signOutUseCase,
      signInWithEmailAndPasswordUseCase: signInWithEmailAndPasswortUseCase,
      signInWithGoogleUseCase: signInWithGoogleUseCase);
});
