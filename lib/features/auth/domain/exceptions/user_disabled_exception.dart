import 'package:repondo/features/auth/domain/constants/auth_error_messages.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

class UserDisabledException extends AuthException {
  UserDisabledException({super.code}) : super(AuthErrorMessages.userDisabled);
}
