import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/application/facades/email_auth_facade.dart';
import 'package:repondo/features/auth/providers/usecases/email_auth/exports.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'email_auth_facade_provider.g.dart';

@riverpod
EmailAuthFacade emailAuthFacade(Ref ref) {
  final signInWithEmailUseCase = ref.read(signInWithEmailProvider);
  final signOutFromEmailUseCase = ref.read(signOutFromEmailProvider);
  final signUpWithEmailUseCase = ref.read(signUpWithEmailProvider);
  final getCurrentUserUseCase = ref.read(getCurrentUserFromEmailProvider);
  final observeUserFromEmailUseCase = ref.read(observeUserFromEmailProvider);

  return EmailAuthFacade(
    signInWithEmailUseCase: signInWithEmailUseCase,
    signUpWithEmailUseCase: signUpWithEmailUseCase,
    signOutFromEmaildUseCase: signOutFromEmailUseCase,
    getCurrentUserFromEmailUseCase: getCurrentUserUseCase,
    observeUserFromEmailUseCase: observeUserFromEmailUseCase,
  );
}
