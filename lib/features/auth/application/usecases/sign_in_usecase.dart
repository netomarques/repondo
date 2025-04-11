import 'package:repondo/features/auth/domain/entities/usuario.dart';
import 'package:repondo/features/auth/domain/repositores/auth.Repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<Usuario> execute() => repository.loginAnonimo();
}
