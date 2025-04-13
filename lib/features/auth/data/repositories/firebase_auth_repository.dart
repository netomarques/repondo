import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:repondo/features/auth/domain/exports.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthRepository(this._firebaseAuth, this._googleSignIn);

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

  @override
  Future<Usuario> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _toUsuario(userCredential.user!);
  }

  @override
  Future<Usuario> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Login cancelado');

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return _toUsuario(userCredential.user!);
  }

  Usuario _toUsuario(User user) {
    return Usuario(
      id: user.uid,
      nome: user.displayName ?? '',
      email: user.email ?? '',
    );
  }
}
