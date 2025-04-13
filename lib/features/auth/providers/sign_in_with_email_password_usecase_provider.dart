import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/application/usecases/sign_in_with_email_and_password_usecase.dart';
import 'package:repondo/features/auth/providers/auth_repository_provider.dart';

final signInWithEmailAndPasswordProvider =
    Provider<SignInWithEmailAndPasswordUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return SignInWithEmailAndPasswordUseCase(repository);
});
