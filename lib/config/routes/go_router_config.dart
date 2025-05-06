import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:repondo/config/navigator/navigator_key.dart';
import 'package:repondo/config/routes/app_routes.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/presentation/exports.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'go_router_config.g.dart';

@Riverpod(keepAlive: true)
GoRouter goRouterConfig(Ref ref) {
  final googleAuthState = ref.watch(googleAuthNotifierProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AuthRouteLocations.splash,
    debugLogDiagnostics: true,
    routes: AppRoutes.routes,
    redirect: (context, state) {
      final location = state.matchedLocation;

      return googleAuthState.when(
        data: (userAuth) {
          return location == AuthRouteLocations.home
              ? null
              : AuthRouteLocations.home;
        },
        error: (error, _) {
          if (error is AuthException && error.message == 'Conta desativada') {
            return location == AuthRouteLocations.conta_desativada
                ? null
                : AuthRouteLocations.conta_desativada;
          }
          return location == AuthRouteLocations.login
              ? null
              : AuthRouteLocations.login;
        },
        loading: () {
          return location == AuthRouteLocations.splash
              ? null
              : AuthRouteLocations.splash;
        },
      );
    },
  );
}
