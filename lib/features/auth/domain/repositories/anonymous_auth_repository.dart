import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

abstract class AnonymousAuthRepository {
  Future<Result<UserAuth, AuthException>> signInWithAnonymous();
  Future<Result<void, AuthException>> signOut();
  Future<Result<UserAuth?, AuthException>> getCurrentUser();
  Stream<Result<UserAuth?, AuthException>> get userStream;
}
