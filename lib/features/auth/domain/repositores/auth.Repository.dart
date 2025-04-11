import '../entities/usuario.dart';

abstract class AuthRepository {
  Future<Usuario?> getUsuarioAtual();
  Stream<Usuario?> get usuarioStream;
  Future<Usuario> loginAnonimo();
  Future<void> logout();
}
