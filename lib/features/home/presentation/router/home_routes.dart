import 'package:go_router/go_router.dart';
import 'package:repondo/config/navigator/navigator_key.dart';
import 'package:repondo/features/home/presentation/pages/home_page.dart';
import 'package:repondo/features/home/presentation/router/home_route_locations.dart';

class HomeRoutes {
  static final routes = <GoRoute>[
    GoRoute(
      path: HomeRouteLocations.home,
      parentNavigatorKey: navigatorKey,
      name: 'home',
      builder: HomePage.builder,
    ),
  ];
}
