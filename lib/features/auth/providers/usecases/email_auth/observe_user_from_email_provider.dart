import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/application/usecases/email_auth/get_user_stream_from_email_use_case.dart';
import 'package:repondo/features/auth/providers/repositories/email_auth_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'observe_user_from_email_provider.g.dart';

@riverpod
ObserveUserFromEmailUseCase observeUserFromEmail(Ref ref) {
  final emailAuthRepository = ref.read(emailAuthRepositoryProvider);
  return ObserveUserFromEmailUseCase(emailAuthRepository);
}
