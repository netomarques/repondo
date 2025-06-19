import 'package:repondo/features/auth/domain/constants/auth_error_messages.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

class InvalidEmailException extends AuthException {
  InvalidEmailException({super.code}) : super(AuthErrorMessages.invalidEmail);
}
