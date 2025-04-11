import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/application/usecases/sign_out_usecase.dart';
import 'package:repondo/features/auth/providers/auth_repository_provider.dart';

final singOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return SignOutUseCase(repository);
});
