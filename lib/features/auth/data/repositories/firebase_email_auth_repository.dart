import 'package:firebase_auth/firebase_auth.dart';
import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/auth/data/exports.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/domain/repositories/email_auth_repository.dart';

class FirebaseEmailAuthRepository implements EmailAuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseEmailAuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<Result<UserAuth, AuthException>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Success(userCredential.user!.toUserAuth());
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-email':
          return Failure(AuthException('Credenciais inválidas', code: e.code));
        case 'user-not-found':
          return Failure(AuthException('Usuário não existe', code: e.code));
        case 'user-disabled':
          return Failure(AuthException('Conta desativada', code: e.code));
        default:
          return Failure(AuthException('Erro de autenticação: ${e.message}',
              code: e.code));
      }
    } catch (ex) {
      return Failure(AuthException('Erro de autenticação: $ex'));
    }
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
