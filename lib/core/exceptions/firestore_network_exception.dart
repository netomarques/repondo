import 'package:repondo/core/constants/firebase_repository_error_messages.dart';
import 'package:repondo/core/exceptions/firebase_repository_exception.dart';

class FirestoreNetworkException extends FirebaseRepositoryException {
  FirestoreNetworkException({super.code})
      : super(FirebaseRepositoryErrorMessages.operationError);
}
