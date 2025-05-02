import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:repondo/config/navigator/navigator_key.dart';
import 'package:repondo/config/routes/app_routes.dart';
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart';
import 'package:repondo/features/auth/presentation/exports.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final googleAuthState = ref.watch(googleAuthNotifierProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AuthRouteLocations.login,
    routes: AppRoutes.routes,
    redirect: (context, state) {
      return googleAuthState.when(
        data: (userAuth) {
          return AuthRouteLocations.home;
        },
        error: (err, __) {
          if (err is! AuthException &&
              (err as AuthException).message == 'Conta desativada') {
            return AuthRouteLocations.conta_desativada;
          }
          return AuthRouteLocations.login;
        },
        loading: () {
          return AuthRouteLocations.loading;
        },
      );
    },
  );
});
