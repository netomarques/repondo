import 'package:repondo/features/despensa/data/constants/despensa_error_messages.dart';
import 'package:repondo/features/despensa/domain/exceptions/despensa_exception.dart';

class PermissionDeniedException extends DespensaException {
  PermissionDeniedException({super.code})
      : super(DespensaErrorMessages.permissionDenied);
}
