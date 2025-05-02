import 'package:go_router/go_router.dart';
import 'package:repondo/config/navigator/navigator_key.dart';
import 'package:repondo/features/auth/presentation/auth_route_locations.dart';
import 'package:repondo/features/auth/presentation/pages/home_page.dart';
import 'package:repondo/features/auth/presentation/pages/loading_page.dart';
import 'package:repondo/features/auth/presentation/pages/login_page.dart';

class AuthRoutes {
  static final routes = <GoRoute>[
    GoRoute(
      path: AuthRouteLocations.login,
      parentNavigatorKey: navigatorKey,
      name: 'login',
      builder: LoginPage.builder,
    ),
    GoRoute(
      path: AuthRouteLocations.home,
      parentNavigatorKey: navigatorKey,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AuthRouteLocations.loading,
      parentNavigatorKey: navigatorKey,
      name: 'loading',
      builder: (context, state) => const LoadingPage(),
    ),
  ];
}
