import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:repondo/features/auth/data/mappers/firebase_user_extensions.dart';
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
    return currentUser != null
        ? currentUser.toUserAuth()
        : throw AuthException('Usuário autenticado é null');
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

      final user = userCredential.user;
      if (user == null) {
        throw AuthException('Usuário autenticado é null');
      }

      return user.toUserAuth();
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
    return _firebaseAuth.authStateChanges().map((user) => user != null
        ? user.toUserAuth()
        : throw AuthException('Usuário autenticado é null'));
  }
}
