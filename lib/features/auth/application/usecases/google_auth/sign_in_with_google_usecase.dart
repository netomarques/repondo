import 'package:repondo/features/auth/domain/exports.dart';

class SignInWithGoogle {
  final GoogleAuthRepository repository;

  SignInWithGoogle(this.repository);

  Future<User> execute() {
    return repository.signIn();
  }
}
