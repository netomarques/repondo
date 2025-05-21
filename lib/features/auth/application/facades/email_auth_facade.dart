import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/application/usecases/email_auth/exports.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

class EmailAuthFacade {
  final SignInWithEmailAndPasswordUseCase _signInWithEmailUseCase;
  final SignUpWithEmailUseCase _signUpWithEmailUseCase;

  EmailAuthFacade({
    required SignInWithEmailAndPasswordUseCase signInWithEmailUseCase,
    required SignUpWithEmailUseCase signUpWithEmailUseCase,
  })  : _signInWithEmailUseCase = signInWithEmailUseCase,
        _signUpWithEmailUseCase = signUpWithEmailUseCase;

  Future<Result<UserAuth, AuthException>> signInWithEmail(
    String email,
    String password,
  ) =>
      _signInWithEmailUseCase.execute(email: email, password: password);

  Future<Result<UserAuth, AuthException>> signUpWithEmail(
    String email,
    String password,
  ) =>
      _signUpWithEmailUseCase.execute(email: email, password: password);
}
