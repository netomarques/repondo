import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:repondo/features/auth/domain/exports.dart';

class FirebaseGoogleAuthRepository implements GoogleAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseGoogleAuthRepository(
      {FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<UserAuth> getCurrentUser() async {
    final currentUser = _firebaseAuth.currentUser;
    return _toUser(
        currentUser ?? (throw AuthException('User do Firebase é nulo')));
  }

  @override
  Future<UserAuth> signIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthException('Login com Google cancelado pelo usuário.');
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
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
  Stream<UserAuth> get userStream {
    return _firebaseAuth.authStateChanges().map((user) =>
        _toUser(user ?? (throw AuthException('User do Firebase é nulo'))));
  }

  UserAuth _toUser(User authenticatedUser) {
    return UserAuth(
      id: authenticatedUser.uid,
      name: authenticatedUser.displayName,
      email: authenticatedUser.email,
      photoUrl: authenticatedUser.photoURL,
    );
  }
}
