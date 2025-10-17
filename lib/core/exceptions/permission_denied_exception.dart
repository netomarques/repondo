import 'package:repondo/core/constants/firebase_repository_error_messages.dart';
import 'package:repondo/core/exceptions/firebase_repository_exception.dart';

class PermissionDeniedException extends FirebaseRepositoryException {
  PermissionDeniedException({super.code})
      : super(FirebaseRepositoryErrorMessages.permissionDenied);
}
