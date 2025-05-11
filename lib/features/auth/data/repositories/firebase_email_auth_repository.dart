import 'package:firebase_auth/firebase_auth.dart';
import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/auth/data/exports.dart';
import 'package:repondo/features/auth/domain/exports.dart';

class FirebaseEmailAuthRepository implements EmailAuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseEmailAuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<Result<UserAuth, AuthException>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return runCatching(() async {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user!.toUserAuth();
    }, (error) {
      if (error is FirebaseAuthException) {
        return fromFirebaseAuthExceptionMapper(error);
      }
      return AuthException('Erro de autenticação: $error');
    });
  }

  @override
  Future<UserAuth?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<UserAuth> signUp() {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  // TODO: implement userStream
  Stream<UserAuth?> get userStream => throw UnimplementedError();
}
