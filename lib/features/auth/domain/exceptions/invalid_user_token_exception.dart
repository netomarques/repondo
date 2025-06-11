import 'package:repondo/features/auth/domain/constants/auth_error_messages.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

class InvalidUserTokenException extends AuthException {
  InvalidUserTokenException({super.code})
      : super(AuthErrorMessages.invalidUserToken);
}
