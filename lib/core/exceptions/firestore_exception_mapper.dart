import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repondo/core/constants/firebase_repository_error_messages.dart';
import 'package:repondo/core/constants/firestore_error_codes.dart';
import 'package:repondo/core/exceptions/document_not_found_exception.dart';
import 'package:repondo/core/exceptions/firebase_repository_exception.dart';
import 'package:repondo/core/exceptions/firestore_network_exception.dart';
import 'package:repondo/core/exceptions/permission_denied_exception.dart';

FirebaseRepositoryException fromFirestoreExceptionMapper(
  FirebaseException error,
) {
  switch (error.code) {
    case FirestoreErrorCodes.unavailable:
    case FirestoreErrorCodes.deadlineExceeded:
    case FirestoreErrorCodes.aborted:
    case FirestoreErrorCodes.networkRequestFailed:
      return FirestoreNetworkException(code: error.code);
    case FirestoreErrorCodes.notFound:
      return DocumentNotFoundException();
    case FirestoreErrorCodes.permissionDenied:
      return PermissionDeniedException();
    default:
      return FirebaseRepositoryException(
        FirebaseRepositoryErrorMessages.unknown,
        code: error.code,
      );
  }
}
