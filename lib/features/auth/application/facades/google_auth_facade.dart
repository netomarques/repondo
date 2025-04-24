import 'package:repondo/features/auth/application/usecases/google_auth/exports.dart';
import 'package:repondo/features/auth/domain/entities/user.dart';

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

  Future<User> signInWithGoogle() {
    return _signInWithGoogleUseCase.execute();
  }

  Future<void> signOut() async {
    await _signOutFromGoogleUseCase.execute();
  }

  Future<User> getCurrentUser() {
    return _getCurrentUserUseCase.fetch();
  }

  Stream<User> observeUserStream() {
    return _getUserStreamUseCase.fetch();
  }
}
