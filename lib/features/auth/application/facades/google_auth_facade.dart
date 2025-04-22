import 'package:repondo/features/auth/application/usecases/google_auth/exports.dart';
import 'package:repondo/features/auth/domain/entities/user.dart';

class GoogleAuthFacade {
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignOutFromGoogleUseCase signOutFromGoogleUseCase;
  final GetCurrentUserFromGoogleUseCase getCurrentUserUseCase;
  final GetUserStreamFromGoogleUseCase getUserStreamUseCase;

  GoogleAuthFacade({
    required this.signInWithGoogleUseCase,
    required this.signOutFromGoogleUseCase,
    required this.getCurrentUserUseCase,
    required this.getUserStreamUseCase,
  });

  Future<User> signInWithGoogle() {
    return signInWithGoogleUseCase.execute();
  }

  Future<void> signOut() async {
    await signOutFromGoogleUseCase.execute();
  }

  Future<User> getCurrentUser() async {
    return getCurrentUserUseCase.fetch();
  }

  Stream<User> observeUserStream() {
    return getUserStreamUseCase.fetch();
  }
}
