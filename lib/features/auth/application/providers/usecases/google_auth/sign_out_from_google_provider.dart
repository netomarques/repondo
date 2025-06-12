import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/application/providers/repositories/google_auth_repository_provider.dart';
import 'package:repondo/features/auth/application/usecases/google_auth/sign_out_from_google_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_out_from_google_provider.g.dart';

@riverpod
SignOutFromGoogleUseCase signOutFromGoogle(Ref ref) {
  final repository = ref.read(googleAuthRepositoryProvider);
  return SignOutFromGoogleUseCase(repository);
}
