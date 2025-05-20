import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/domain/repositories/email_auth_repository.dart';

/// Use case responsável por obter o usuário autenticado via email e senha.
/// Retorna um [UserAuth] se estiver logado, ou `null` se não houver usuário.
class GetCurrentUserFromEmailUseCase {
  final EmailAuthRepository _repository;

  GetCurrentUserFromEmailUseCase(this._repository);

  Future<Result<UserAuth?, AuthException>> fetch() {
    return _repository.getCurrentUser();
  }
}
