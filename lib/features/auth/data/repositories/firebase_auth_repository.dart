import 'package:firebase_auth/firebase_auth.dart';
import 'package:repondo/features/auth/domain/entities/usuario.dart';
import 'package:repondo/features/auth/domain/repositores/auth.Repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository(this._firebaseAuth);

  @override
  Future<Usuario?> getUsuarioAtual() async {
    final user = _firebaseAuth.currentUser;
    return user != null ? _toUsuario(user) : null;
  }

  @override
  Stream<Usuario?> get usuarioStream {
    return _firebaseAuth
        .authStateChanges()
        .map((user) => user != null ? _toUsuario(user) : null);
  }

  @override
  Future<Usuario> loginAnonimo() async {
    final credential = await _firebaseAuth.signInAnonymously();
    return _toUsuario(credential.user!);
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Usuario _toUsuario(User user) {
    return Usuario(
      id: user.uid,
      nome: user.displayName ?? '',
      email: user.email ?? '',
    );
  }
}
