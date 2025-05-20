import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/domain/repositories/email_auth_repository.dart';

/// Caso de uso responsável por realizar o logout do usuário autenticado via email e senha.
class SignOutFromEmailAndPasswordUseCase {
  final EmailAuthRepository _repository;

  SignOutFromEmailAndPasswordUseCase(this._repository);

  Future<Result<void, AuthException>> execute() => _repository.signOut();
}
