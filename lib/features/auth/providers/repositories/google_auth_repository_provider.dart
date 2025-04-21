import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:repondo/features/auth/data/repositories/firebase_google_auth_repository.dart';
import 'package:repondo/features/auth/domain/repositories/google_auth_repository.dart';

final googleAuthRepositoryProvider = Provider<GoogleAuthRepository>((ref) {
  return FirebaseGoogleAuthRepository(
    firebaseAuth: FirebaseAuth.instance,
    googleSignIn: GoogleSignIn(),
  );
});
