import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/application/usecases/sign_in_usecase.dart';
import 'package:repondo/features/auth/providers/auth_repository_provider.dart';

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return SignInUseCase(repository);
});
