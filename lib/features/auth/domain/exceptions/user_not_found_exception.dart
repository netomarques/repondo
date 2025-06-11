import 'package:repondo/features/auth/domain/constants/auth_error_messages.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

class UserNotFoundException extends AuthException {
  UserNotFoundException({super.code}) : super(AuthErrorMessages.userNotFound);
}
