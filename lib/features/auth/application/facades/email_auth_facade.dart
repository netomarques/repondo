import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/auth/application/usecases/email_auth/exports.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

class EmailAuthFacade {
  final SignInWithEmailAndPasswordUseCase _signInWithEmailUseCase;
  final SignUpWithEmailUseCase _signUpWithEmailUseCase;
  final SignOutFromEmailAndPasswordUseCase _signOutFromEmaildUseCase;
  final GetCurrentUserFromEmailUseCase _getCurrentUserFromEmailUseCase;
  final ObserveUserFromEmailUseCase _observeUserFromEmailUseCase;

  EmailAuthFacade({
    required SignInWithEmailAndPasswordUseCase signInWithEmailUseCase,
    required SignUpWithEmailUseCase signUpWithEmailUseCase,
    required SignOutFromEmailAndPasswordUseCase signOutFromEmaildUseCase,
    required GetCurrentUserFromEmailUseCase getCurrentUserFromEmailUseCase,
    required ObserveUserFromEmailUseCase observeUserFromEmailUseCase,
  })  : _signInWithEmailUseCase = signInWithEmailUseCase,
        _signUpWithEmailUseCase = signUpWithEmailUseCase,
        _signOutFromEmaildUseCase = signOutFromEmaildUseCase,
        _getCurrentUserFromEmailUseCase = getCurrentUserFromEmailUseCase,
        _observeUserFromEmailUseCase = observeUserFromEmailUseCase;

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

  Future<Result<void, AuthException>> signOut() =>
      _signOutFromEmaildUseCase.execute();

  Future<Result<UserAuth?, AuthException>> getCurrentUser() =>
      _getCurrentUserFromEmailUseCase.fetch();

  Stream<Result<UserAuth?, AuthException>> get observeUserAuth =>
      _observeUserFromEmailUseCase.observe();
}
