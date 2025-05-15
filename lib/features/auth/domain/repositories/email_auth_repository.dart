import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

abstract class EmailAuthRepository {
  Future<Result<UserAuth, AuthException>> signInWithEmailAndPassword(
      String email, String password);
  Future<Result<UserAuth, AuthException>> signUpWithEmailAndPassword(
      String email, String password);
  Future<Result<void, AuthException>> signOut();
  Future<Result<UserAuth?, AuthException>> getCurrentUser();
  Stream<UserAuth?> get userStream;
}
