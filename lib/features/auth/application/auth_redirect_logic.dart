import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/presentation/router/auth_route_locations.dart';

/// Essa função é reativa e responde às mudanças no estado de autenticação.
String? authRedirectLogic({
  required AsyncValue<UserAuth?> authState,
  required String currentLocation,
}) {
  String? maybeRedirectTo(String location) {
    return currentLocation == location ? null : location;
  }

  return authState.when(
    // Usuário autenticado com sucesso
    data: (userAuth) => maybeRedirectTo(
        userAuth != null ? AuthRouteLocations.home : AuthRouteLocations.login),
    // Erro ao obter estado de autenticação
    error: (error, _) {
      // Caso específico: conta desativada
      if (error is AuthException && error.message == 'Conta desativada') {
        return maybeRedirectTo(AuthRouteLocations.conta_desativada);
      }
      // Redireciona para login em qualquer outro erro
      return maybeRedirectTo(AuthRouteLocations.login);
    },
    // Estado de carregamento: redireciona para splash
    loading: () => maybeRedirectTo(AuthRouteLocations.splash),
  );
}
