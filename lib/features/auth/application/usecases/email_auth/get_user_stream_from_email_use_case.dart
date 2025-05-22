import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/domain/repositories/email_auth_repository.dart';

class ObserveUserFromEmailUseCase {
  final EmailAuthRepository _repository;

  ObserveUserFromEmailUseCase(this._repository);

  Stream<Result<UserAuth?, AuthException>> observe() => _repository.userStream;
}
