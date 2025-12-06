import 'package:repondo/core/exceptions/firebase_repository_exception.dart';
import 'package:repondo/core/exceptions/permission_denied_exception.dart';
import 'package:repondo/features/item/domain/exceptions/item_exception.dart';

ItemException fromFirebaseItemExceptionMapper(
    FirebaseRepositoryException error) {
  return switch (error) {
    PermissionDeniedException() =>
      ItemPermissionDeniedException(code: error.code),
    _ => ItemUnknownException(code: error.code),
  };
}
