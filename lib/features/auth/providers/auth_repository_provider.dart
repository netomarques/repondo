import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:repondo/features/auth/data/repositories/firebase_auth_repository.dart';

final authRepositoryProvider = Provider<FirebaseAuthRepository>((ref) {
  return FirebaseAuthRepository(FirebaseAuth.instance, GoogleSignIn());
});
