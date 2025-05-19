import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/application/usecases/exports.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserAuth user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class AuthNotifier extends StateNotifier<AuthState> {
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  final SignInWithEmailAndPasswordUseCase signInWithEmailAndPasswordUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;

  AuthNotifier({
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.signInWithEmailAndPasswordUseCase,
    required this.signInWithGoogleUseCase,
  }) : super(AuthInitial());

  Future<void> login() async {
    state = AuthLoading();
    final user = await signInUseCase.execute();
    state = Authenticated(user!);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = AuthLoading();
    try {
      final user = await signInUseCase.execute();
      state = Authenticated(user!);
    } catch (e) {
      state = Unauthenticated();
    }
  }

  Future<void> signInWithGoogle() async {
    state = AuthLoading();
    try {
      final user = await signInWithGoogleUseCase.execute();
      state = Authenticated(user);
    } catch (e) {
      state = Unauthenticated();
    }
  }

  Future<void> logout() async {
    await signOutUseCase.execute();
    state = Unauthenticated();
  }
}
