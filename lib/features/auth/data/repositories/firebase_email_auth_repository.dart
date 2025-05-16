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

      if (userCredential.user == null) {
        throw AuthException('Usuário retornado é null após autenticação');
      }

      return userCredential.user!.toUserAuth();
    }, (error) {
      if (error is FirebaseAuthException) {
        return fromFirebaseAuthExceptionMapper(error);
      }
      return AuthException('Erro de autenticação: $error');
    });
  }

  @override
  Future<Result<UserAuth?, AuthException>> getCurrentUser() async {
    return Success(_firebaseAuth.currentUser?.toUserAuth());
  }

  @override
  Future<Result<void, AuthException>> signOut() {
    return runCatching(
      () async => await _firebaseAuth.signOut(),
      (error) {
        if (error is FirebaseAuthException) {
          return fromFirebaseAuthExceptionMapper(error);
        }
        return AuthException('Erro no logout: $error');
      },
    );
  }

  @override
  Future<Result<UserAuth, AuthException>> signUpWithEmailAndPassword(
      String email, String password) async {
    return runCatching(() async {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user == null) {
        throw AuthException('Usuário é null após a criação');
      }

      return userCredential.user!.toUserAuth();
    }, (error) {
      if (error is FirebaseAuthException) {
        return fromFirebaseAuthExceptionMapper(error);
      }
      return AuthException('Erro ao criar conta: $error');
    });
  }

  @override
  Stream<Result<UserAuth?, AuthException>> get userStream => _firebaseAuth
      .authStateChanges()
      .map((user) => Success(user?.toUserAuth()));
}
