import 'package:go_router/go_router.dart';
import 'package:repondo/config/navigator/navigator_key.dart';
import 'package:repondo/features/auth/presentation/pages/exports.dart';
import 'package:repondo/features/auth/presentation/pages/loading_page.dart';
import 'package:repondo/features/auth/presentation/router/auth_route_locations.dart';

class AuthRoutes {
  static final routes = <GoRoute>[
    GoRoute(
      path: AuthRouteLocations.splash,
      parentNavigatorKey: navigatorKey,
      name: 'splash',
      builder: SplashPage.builder,
    ),
    GoRoute(
      path: AuthRouteLocations.login,
      parentNavigatorKey: navigatorKey,
      name: 'login',
      builder: LoginPage.builder,
    ),
    GoRoute(
      path: AuthRouteLocations.signUp,
      parentNavigatorKey: navigatorKey,
      name: 'signUp',
      builder: SignUpPage.builder,
    ),
    GoRoute(
      path: AuthRouteLocations.loading,
      parentNavigatorKey: navigatorKey,
      name: 'loading',
      builder: LoadingPage.builder,
    ),
  ];
}
