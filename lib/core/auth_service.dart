import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthService({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  // Getter para usuário autenticado
  User? get currentUser => _auth.currentUser;

  // Registro com email e senha
  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseError(e.code);
    } catch (e) {
      throw AuthException('Erro ao registrar novo usuário com email e senha');
    }
  }

  // Login com email e senha
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseError(e.code);
    } catch (e) {
      throw AuthException('Erro desconhecido ao fazer login com email e senha');
    }
  }

  // Login com Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // O usuário cancelou o login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseError(e.code);
    } catch (e) {
      throw AuthException('Erro ao fazer login com o Google');
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}

// Classe para mapear erros do Firebase
class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  static AuthException fromFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return AuthException('O e-mail já está em uso.');
      case 'wrong-password':
        return AuthException('Senha incorreta.');
      case 'user-not-found':
        return AuthException('Usuário não encontrado.');
      case 'invalid-email':
        return AuthException('E-mail inválido.');
      case 'user-disabled':
        return AuthException('Esta conta foi desativada.');
      case 'too-many-requests':
        return AuthException(
            'Muitas tentativas de login. Tente novamente mais tarde.');
      default:
        return AuthException('Erro desconhecido.');
    }
  }

  @override
  String toString() => message;
}
