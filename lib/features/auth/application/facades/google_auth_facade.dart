import 'package:repondo/features/auth/application/usecases/google_auth/exports.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';

class GoogleAuthFacade {
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignOutFromGoogleUseCase _signOutFromGoogleUseCase;
  final GetCurrentUserFromGoogleUseCase _getCurrentUserUseCase;
  final GetUserStreamFromGoogleUseCase _getUserStreamUseCase;

  GoogleAuthFacade({
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required SignOutFromGoogleUseCase signOutFromGoogleUseCase,
    required GetCurrentUserFromGoogleUseCase getCurrentUserUseCase,
    required GetUserStreamFromGoogleUseCase getUserStreamUseCase,
  })  : _signInWithGoogleUseCase = signInWithGoogleUseCase,
        _signOutFromGoogleUseCase = signOutFromGoogleUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _getUserStreamUseCase = getUserStreamUseCase;

  Future<UserAuth> signInWithGoogle() {
    return _signInWithGoogleUseCase.execute();
  }

  Future<void> signOut() async {
    await _signOutFromGoogleUseCase.execute();
  }

  Future<UserAuth> getCurrentUser() {
    return _getCurrentUserUseCase.fetch();
  }

  Stream<UserAuth> observeUserStream() {
    return _getUserStreamUseCase.fetch();
  }
}
