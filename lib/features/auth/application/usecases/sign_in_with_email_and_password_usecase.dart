import 'package:repondo/features/auth/domain/exports.dart';

class SignInWithEmailAndPasswordUseCase {
  final AuthRepository repository;

  SignInWithEmailAndPasswordUseCase(this.repository);

  Future<Usuario> execute(String email, String password) =>
      repository.signInWithEmailAndPassword(email, password);
}
