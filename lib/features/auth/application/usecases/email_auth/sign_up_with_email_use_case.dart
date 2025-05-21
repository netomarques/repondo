import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/domain/repositories/email_auth_repository.dart';

class SignUpWithEmailUseCase {
  final EmailAuthRepository _repository;

  SignUpWithEmailUseCase(this._repository);

  Future<Result<UserAuth, AuthException>> execute({
    required String email,
    required String password,
  }) async =>
      _repository.signUpWithEmailAndPassword(email, password);
}
