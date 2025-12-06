import 'package:repondo/core/exceptions/app_exception.dart';
import 'package:repondo/features/item/domain/constants/item_error_messages.dart';

sealed class ItemException extends AppException {
  ItemException(super.message, {super.code});
}

final class ItemUnknownException extends ItemException {
  ItemUnknownException({super.code})
      : super(ItemErrorMessages.itemUnknownError);
}

final class ItemPermissionDeniedException extends ItemException {
  ItemPermissionDeniedException({super.code})
      : super(ItemErrorMessages.permissionDenied);
}

final class ItemFetchAfterCreateException extends ItemException {
  ItemFetchAfterCreateException({super.code})
      : super(ItemErrorMessages.fetchAfterCreateError);
}
