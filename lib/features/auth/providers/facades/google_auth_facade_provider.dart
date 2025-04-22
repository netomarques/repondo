import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/application/facades/exports.dart';
import 'package:repondo/features/auth/providers/usecases/google_auth/exports.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google_auth_facade_provider.g.dart';

@riverpod
GoogleAuthFacade googleAuthFacade(Ref ref) {
  final signInWithGoogleUseCase = ref.read(signInWithGoogleProvider);
  final signOutFromGoogleUseCase = ref.read(signOutFromGoogleProvider);
  final getCurrentUserUseCase = ref.read(getCurrentUserFromGoogleProvider);
  final getUserStreamUseCase = ref.read(getUserStreamFromGoogleProvider);

  return GoogleAuthFacade(
    signInWithGoogleUseCase: signInWithGoogleUseCase,
    signOutFromGoogleUseCase: signOutFromGoogleUseCase,
    getCurrentUserUseCase: getCurrentUserUseCase,
    getUserStreamUseCase: getUserStreamUseCase,
  );
}
