import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/application/providers/repositories/email_auth_repository_provider.dart';
import 'package:repondo/features/auth/application/usecases/email_auth/sign_up_with_email_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_with_email_provider.g.dart';

/// Provider do usecase para cadastro com email e senha.
@riverpod
SignUpWithEmailUseCase signUpWithEmail(Ref ref) {
  final emailAuthRepository = ref.read(emailAuthRepositoryProvider);
  return SignUpWithEmailUseCase(emailAuthRepository);
}
