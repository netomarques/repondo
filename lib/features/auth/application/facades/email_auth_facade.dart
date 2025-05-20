import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/application/usecases/email_auth/exports.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

class EmailAuthFacade {
  final SignInWithEmailAndPasswordUseCase _signInWithEmailUseCase;

  EmailAuthFacade({
    required SignInWithEmailAndPasswordUseCase signInWithEmailUseCase,
  }) : _signInWithEmailUseCase = signInWithEmailUseCase;

  Future<Result<UserAuth, AuthException>> signInWithEmail(
    String email,
    String password,
  ) =>
      _signInWithEmailUseCase.execute(email: email, password: password);
}
