import 'package:firebase_auth/firebase_auth.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/core/result/result_helpers.dart';
import 'package:repondo/features/auth/data/exports.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/domain/exceptions/firebase_auth_exception_mapper.dart';
import 'package:repondo/features/auth/domain/repositories/anonymous_auth_repository.dart';

class FirebaseAnonymousAuthRepository implements AnonymousAuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAnonymousAuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<Result<UserAuth?, AuthException>> getCurrentUser() async {
    return Success(_firebaseAuth.currentUser?.toUserAuth());
  }

  @override
  Future<Result<UserAuth, AuthException>> signInWithAnonymous() {
    return runCatching(() async {
      final userCredential = await _firebaseAuth.signInAnonymously();
      if (userCredential.user == null) {
        throw AuthException('Após o login usuário é null');
      }
      return userCredential.user!.toUserAuth();
    }, (error) {
      if (error is AuthException) return error;

      if (error is FirebaseAuthException) {
        return fromFirebaseAuthExceptionMapper(error);
      }

      return AuthException('Erro ao autenticar como anônimo: $error');
    });
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
  // TODO: implement userStream
  Stream<Result<UserAuth?, AuthException>> get userStream =>
      throw UnimplementedError();
}
