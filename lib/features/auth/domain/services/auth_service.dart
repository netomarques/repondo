import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

abstract class AuthService {
  Future<Result<UserAuth?, AuthException>> getCurrentUser();
  Future<Result<bool, AuthException>> isAuthenticated();
  Stream<Result<UserAuth?, AuthException>> get userStream;
}
