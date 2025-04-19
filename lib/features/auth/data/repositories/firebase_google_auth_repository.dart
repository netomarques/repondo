import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/domain/exports.dart' as authDomain;

class FirebaseGoogleAuthRepository implements authDomain.GoogleAuthRepository {
  final fbAuth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseGoogleAuthRepository(
      {fbAuth.FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth ?? fbAuth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<authDomain.User> getCurrentUser() async {
    final currentUser = _firebaseAuth.currentUser;
    return _toUser(
        currentUser ?? (throw AuthException('User do Firebase é nulo')));
  }

  @override
  Future<authDomain.User> signIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthException('Login com Google cancelado pelo usuário.');
      }

      final googleAuth = await googleUser.authentication;

      final credential = fbAuth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      return _toUser(userCredential.user ??
          (throw AuthException('Usuário Firebase é nulo após autenticação.')));
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Erro inesperado durante o login: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException('Erro ao fazer logout');
    }
  }

  @override
  Stream<authDomain.User> get userStream {
    return _firebaseAuth.authStateChanges().map((user) =>
        _toUser(user ?? (throw AuthException('User do Firebase é nulo'))));
  }

  authDomain.User _toUser(fbAuth.User authenticatedUser) {
    return authDomain.User(
      id: authenticatedUser.uid,
      name: authenticatedUser.displayName ?? '',
      email: authenticatedUser.email ?? '',
    );
  }
}
