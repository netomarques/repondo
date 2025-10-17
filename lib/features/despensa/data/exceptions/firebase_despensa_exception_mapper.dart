import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repondo/features/despensa/data/constants/firebase_despensa_error_codes.dart';
import 'package:repondo/features/despensa/domain/exceptions/exports.dart';

DespensaException fromFirebaseDespensaExceptionMapper(FirebaseException error) {
  switch (error.code) {
    case FirebaseDespensaErrorCodes.permissionDenied:
      return DespensaPermissionDeniedException(code: error.code);
    default:
      return DespensaUnknownException(code: error.code);
  }
}
