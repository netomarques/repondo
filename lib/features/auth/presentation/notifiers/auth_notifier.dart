import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/application/usecases/sign_in_usecase.dart';
import 'package:repondo/features/auth/application/usecases/sign_out_usecase.dart';
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

  AuthNotifier({
    required this.signInUseCase,
    required this.signOutUseCase,
  }) : super(AuthInitial());

  Future<void> login() async {
    state = AuthLoading();
    final usuario = await signInUseCase.execute();
    state = Authenticated(usuario);
  }

  Future<void> logout() async {
    await signOutUseCase.execute();
    state = Unauthenticated();
  }
}
