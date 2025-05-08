import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/presentation/router/auth_route_locations.dart';

/// Essa função é reativa e responde às mudanças no estado de autenticação.
String? authRedirectLogic(
    {required AsyncValue<UserAuth> googleAuthState,
    required String currentLocation}) {
  return googleAuthState.when(
    // Usuário autenticado com sucesso
    data: (userAuth) {
      return currentLocation == AuthRouteLocations.home
          ? null // Já está na rota correta
          : AuthRouteLocations.home; // Redireciona para a home
    },
    // Erro ao obter estado de autenticação
    error: (error, _) {
      // Caso específico: conta desativada
      if (error is AuthException && error.message == 'Conta desativada') {
        return currentLocation == AuthRouteLocations.conta_desativada
            ? null
            : AuthRouteLocations.conta_desativada;
      }
      // Redireciona para login em qualquer outro erro
      return currentLocation == AuthRouteLocations.login
          ? null
          : AuthRouteLocations.login;
    },
    // Estado de carregamento: redireciona para splash
    loading: () {
      return currentLocation == AuthRouteLocations.splash
          ? null
          : AuthRouteLocations.splash;
    },
  );
}
