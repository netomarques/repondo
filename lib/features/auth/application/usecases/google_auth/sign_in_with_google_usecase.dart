import 'package:repondo/features/auth/domain/exports.dart';

class SignInWithGoogleUseCase {
  final GoogleAuthRepository _repository;

  SignInWithGoogleUseCase(this._repository);

  Future<User> execute() => _repository.signIn();
}
