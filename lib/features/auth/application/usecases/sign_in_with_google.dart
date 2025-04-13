import 'package:repondo/features/auth/domain/exports.dart';

class SignInWithGoogle {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  Future<User> execute() {
    return repository.signInWithGoogle();
  }
}
