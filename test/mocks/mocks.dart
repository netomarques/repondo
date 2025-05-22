import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:repondo/features/auth/application/facades/exports.dart';
import 'package:repondo/features/auth/application/usecases/exports.dart';
import 'package:repondo/features/auth/domain/repositories/exports.dart';

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
  GoogleAuthFacade,
  BuildContext,
  GoRouterState,
  EmailAuthRepository,
  SignInWithEmailAndPasswordUseCase,
  SignUpWithEmailUseCase,
  SignOutFromEmailAndPasswordUseCase,
  GetCurrentUserFromEmailUseCase,
  ObserveUserFromEmailUseCase
])
void main() {}
