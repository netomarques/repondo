import 'package:repondo/features/auth/domain/exports.dart';

class SignInWithGoogleUseCase {
  final GoogleAuthRepository _repository;

  SignInWithGoogleUseCase(this._repository);

  Future<UserAuth> execute() => _repository.signIn();
}
