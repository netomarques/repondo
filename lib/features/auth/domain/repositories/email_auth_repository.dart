import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

abstract class EmailAuthRepository {
  Future<Result<UserAuth, AuthException>> signInWithEmailAndPassword(
      String email, String password);
  Future<UserAuth> signUp();
  Future<void> signOut();
  Future<Result<UserAuth?, AuthException>> getCurrentUser();
  Stream<UserAuth?> get userStream;
}
