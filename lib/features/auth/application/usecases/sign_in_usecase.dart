import 'package:repondo/features/auth/domain/exports.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<Usuario> execute() => repository.loginAnonimo();
}
