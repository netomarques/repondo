import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:repondo/features/auth/application/facades/exports.dart';
import 'package:repondo/features/auth/application/usecases/exports.dart';
import 'package:repondo/features/auth/domain/repositories/google_auth_repository.dart';

@GenerateMocks([
  FirebaseAuth,
  UserCredential,
  User,
  UserInfo,
  GoogleSignIn,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
  GoogleAuthRepository,
  SignInWithGoogleUseCase,
  SignOutFromGoogleUseCase,
  GetCurrentUserFromGoogleUseCase,
  GetUserStreamFromGoogleUseCase,
  GoogleAuthFacade
])
void main() {}
