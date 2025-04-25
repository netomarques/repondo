import 'package:firebase_auth/firebase_auth.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';

extension FirebaseUserExtensions on User {
  UserAuth toUserAuth() => UserAuth(
        id: uid,
        name: displayName,
        email: email,
        photoUrl: photoURL,
      );
}
