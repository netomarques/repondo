import 'package:repondo/features/auth/domain/constants/auth_error_messages.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';

class InternalErrorException extends AuthException {
  InternalErrorException({super.code}) : super(AuthErrorMessages.internalError);
}
