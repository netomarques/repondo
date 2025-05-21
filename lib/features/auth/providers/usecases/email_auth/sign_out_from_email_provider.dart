import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/application/usecases/email_auth/sign_out_from_email_and_password_use_case.dart';
import 'package:repondo/features/auth/providers/repositories/email_auth_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_out_from_email_provider.g.dart';

/// Provider do usecase para logout com email e senha.
@riverpod
SignOutFromEmailAndPasswordUseCase signOutFromEmail(Ref ref) {
  final emailAuthRepository = ref.read(emailAuthRepositoryProvider);
  return SignOutFromEmailAndPasswordUseCase(emailAuthRepository);
}
