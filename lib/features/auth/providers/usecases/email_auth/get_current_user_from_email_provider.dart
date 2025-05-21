import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/application/usecases/email_auth/get_current_user_from_email_use_case.dart';
import 'package:repondo/features/auth/providers/repositories/email_auth_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_current_user_from_email_provider.g.dart';

/// Provider do usecase que retorna o usuário autenticado via email.
@riverpod
GetCurrentUserFromEmailUseCase getCurrentUserFromEmail(Ref ref) {
  final emailAuthRepository = ref.read(emailAuthRepositoryProvider);
  return GetCurrentUserFromEmailUseCase(emailAuthRepository);
}
