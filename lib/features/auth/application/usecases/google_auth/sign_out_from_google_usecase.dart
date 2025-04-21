import 'package:repondo/features/auth/domain/repositories/google_auth_repository.dart';

class SignOutFromGoogleUseCase {
  final GoogleAuthRepository _repository;

  SignOutFromGoogleUseCase(this._repository);

  Future<void> execute() => _repository.signOut();
}
