import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/domain/repositories/email_auth_repository.dart';

class SignInWithEmailAndPasswordUseCase {
  final EmailAuthRepository repository;

  SignInWithEmailAndPasswordUseCase(this.repository);

  Future<Result<UserAuth, AuthException>> execute({
    required String email,
    required String password,
  }) =>
      repository.signInWithEmailAndPassword(email, password);
}
