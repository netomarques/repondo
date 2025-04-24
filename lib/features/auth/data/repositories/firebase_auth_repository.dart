import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:repondo/features/auth/domain/exports.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthRepository(this._firebaseAuth, this._googleSignIn);

  @override
  Future<UserAuth?> getCurrentUser() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null ? _toUser(currentUser) : null;
  }

  @override
  Stream<UserAuth?> get userStream {
    return _firebaseAuth
        .authStateChanges()
        .map((user) => user != null ? _toUser(user) : null);
  }

  @override
  Future<UserAuth> signInAnonymously() async {
    final credential = await _firebaseAuth.signInAnonymously();
    return _toUser(credential.user!);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserAuth> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _toUser(userCredential.user!);
  }

  @override
  Future<UserAuth> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Login cancelado');

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return _toUser(userCredential.user!);
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
