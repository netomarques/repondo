import 'package:repondo/features/despensa/data/constants/despensa_error_messages.dart';
import 'package:repondo/features/despensa/domain/exceptions/despensa_exception.dart';

class DespensaUnknownException extends DespensaException {
  DespensaUnknownException({super.code})
      : super(DespensaErrorMessages.despensaUnknownError);
}
