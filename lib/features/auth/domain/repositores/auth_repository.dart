import '../entities/usuario.dart';

abstract class AuthRepository {
  Future<Usuario?> getUsuarioAtual();
  Stream<Usuario?> get usuarioStream;
  Future<Usuario> loginAnonimo();
  Future<Usuario> signInWithEmailAndPassword(String email, String password);
  Future<Usuario> signInWithGoogle();
  Future<void> logout();
}
