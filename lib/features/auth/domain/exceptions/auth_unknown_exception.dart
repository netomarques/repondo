import 'package:repondo/features/auth/domain/constants/exports.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

class AuthUnknownException extends AuthException {
  AuthUnknownException({super.code})
      : super(AuthErrorMessages.authUnknownError);
}
