import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/application/usecases/google_auth/sign_in_with_google_usecase.dart';
import 'package:repondo/features/auth/providers/google_auth_repository_provider.dart';

final signInWithGoogleUseCaseProvider =
    Provider<SignInWithGoogleUseCase>((ref) {
  final repository = ref.read(googleAuthRepositoryProvider);
  return SignInWithGoogleUseCase(repository);
});
