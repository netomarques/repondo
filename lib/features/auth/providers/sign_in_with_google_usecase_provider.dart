import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/application/usecases/sign_in_with_google.dart';
import 'package:repondo/features/auth/providers/auth_repository_provider.dart';

final signInWithGoogleUseCaseProvider = Provider<SignInWithGoogle>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return SignInWithGoogle(repository);
});
