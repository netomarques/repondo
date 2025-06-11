import 'package:repondo/features/auth/domain/constants/auth_error_messages.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

class EmailAlreadyInUseException extends AuthException {
  EmailAlreadyInUseException({super.code})
      : super(AuthErrorMessages.emailAlreadyInUse);
}
