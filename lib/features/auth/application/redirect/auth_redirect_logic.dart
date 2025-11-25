import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repondo/features/auth/domain/entities/user_auth.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/presentation/router/auth_route_locations.dart';
import 'package:repondo/features/home/presentation/router/home_route_locations.dart';

/// Essa função é reativa e responde às mudanças no estado de autenticação.
String? authRedirectLogic({
  required AsyncValue<UserAuth?> authState,
  required String currentLocation,
}) {
  String? maybeRedirectTo(String location) {
    if (currentLocation.startsWith(location)) {
      return currentLocation;
    }

    return currentLocation == location ? null : location;
  }

  String? redirectToLoginIfNotOnAuthRoutes() {
    final isLogin = currentLocation == AuthRouteLocations.login;
    final isSignUp = currentLocation == AuthRouteLocations.signUp;

    // se já estiver na login ou signup, permanece
    if (isLogin || isSignUp) return null;
    return AuthRouteLocations.login;
  }

  return authState.when(
    // Usuário autenticado com sucesso
    data: (userAuth) => userAuth != null
        ? maybeRedirectTo(HomeRouteLocations.home)
        : redirectToLoginIfNotOnAuthRoutes(),
    // Erro ao obter estado de autenticação
    error: (error, _) {
      // Caso específico: conta desativada
      if (error is AuthException && error.message == 'Conta desativada') {
        return maybeRedirectTo(AuthRouteLocations.contaDesativada);
      }
      return redirectToLoginIfNotOnAuthRoutes();
    },
    // Estado de carregamento: redireciona para splash
    loading: () => maybeRedirectTo(AuthRouteLocations.splash),
  );
}
