import 'package:firebase_auth/firebase_auth.dart';
import 'package:repondo/features/auth/domain/constants/firebase_auth_error_codes.dart';
import 'package:repondo/features/auth/domain/exceptions/exports.dart';

AuthException fromFirebaseAuthExceptionMapper(FirebaseAuthException error) {
  switch (error.code) {
    case FirebaseAuthErrorCodes.wrongPassword:
    case FirebaseAuthErrorCodes.invalidEmail:
    case FirebaseAuthErrorCodes.invalidCredential:
      return InvalidCredentialsException(code: error.code);
    case FirebaseAuthErrorCodes.userNotFound:
      return UserNotFoundException(code: error.code);
    case FirebaseAuthErrorCodes.userDisabled:
      return UserDisabledException(code: error.code);
    case FirebaseAuthErrorCodes.emailAlreadyInUse:
      return EmailAlreadyInUseException(code: error.code);
    case FirebaseAuthErrorCodes.networkRequestFailed:
      return NetworkRequestFailedException(code: error.code);
    case FirebaseAuthErrorCodes.invalidUserToken:
      return InvalidUserTokenException(code: error.code);
    case FirebaseAuthErrorCodes.internalError:
      return InternalErrorException(code: error.code);
    case FirebaseAuthErrorCodes.weakPassword:
      return WeakPasswordException(code: error.code);
    default:
      return AuthUnknownException(code: error.code);
  }
}
