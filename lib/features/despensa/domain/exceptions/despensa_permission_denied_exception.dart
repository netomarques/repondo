import 'package:repondo/features/despensa/data/constants/despensa_error_messages.dart';
import 'package:repondo/features/despensa/domain/exceptions/despensa_exception.dart';

class DespensaPermissionDeniedException extends DespensaException {
  DespensaPermissionDeniedException({super.code})
      : super(DespensaErrorMessages.permissionDenied);
}
