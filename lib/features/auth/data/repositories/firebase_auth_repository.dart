import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:repondo/features/auth/domain/exports.dart' as authDomain;

class FirebaseAuthRepository implements authDomain.AuthRepository {
  final fbAuth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthRepository(this._firebaseAuth, this._googleSignIn);

  @override
  Future<authDomain.User?> getCurrentUser() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null ? _toUser(currentUser) : null;
  }

  @override
  Stream<authDomain.User?> get userStream {
    return _firebaseAuth
        .authStateChanges()
        .map((user) => user != null ? _toUser(user) : null);
  }

  @override
  Future<authDomain.User> signInAnonymously() async {
    final credential = await _firebaseAuth.signInAnonymously();
    return _toUser(credential.user!);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<authDomain.User> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _toUser(userCredential.user!);
  }

  @override
  Future<authDomain.User> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Login cancelado');

    final googleAuth = await googleUser.authentication;

    final credential = fbAuth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return _toUser(userCredential.user!);
  }

  authDomain.User _toUser(fbAuth.User authenticatedUser) {
    return authDomain.User(
      id: authenticatedUser.uid,
      name: authenticatedUser.displayName ?? '',
      email: authenticatedUser.email ?? '',
    );
  }
}
