import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/application/usecases/exports.dart';
import 'package:repondo/features/auth/domain/entities/usuario.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final Usuario usuario;
  Authenticated(this.usuario);
}

class Unauthenticated extends AuthState {}

class AuthNotifier extends StateNotifier<AuthState> {
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  final SignInWithEmailAndPasswordUseCase signInWithEmailAndPasswordUseCase;
  final SignInWithGoogle signInWithGoogleUseCase;

  AuthNotifier({
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.signInWithEmailAndPasswordUseCase,
    required this.signInWithGoogleUseCase,
  }) : super(AuthInitial());

  Future<void> login() async {
    state = AuthLoading();
    final usuario = await signInUseCase.execute();
    state = Authenticated(usuario);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = AuthLoading();
    try {
      final usuario =
          await signInWithEmailAndPasswordUseCase.execute(email, password);
      state = Authenticated(usuario);
    } catch (e) {
      state = Unauthenticated();
    }
  }

  Future<void> signInWithGoogle() async {
    state = AuthLoading();
    try {
      final usuario = await signInWithGoogleUseCase.execute();
      state = Authenticated(usuario);
    } catch (e) {
      state = Unauthenticated();
    }
  }

  Future<void> logout() async {
    await signOutUseCase.execute();
    state = Unauthenticated();
  }
}
