import 'package:go_router/go_router.dart';
import 'package:repondo/config/navigator/navigator_key.dart';
import 'package:repondo/features/despensa/presentation/router/despensa_routes.dart';
import 'package:repondo/features/home/presentation/pages/home_page.dart';
import 'package:repondo/features/home/presentation/router/home_route_locations.dart';
import 'package:repondo/features/item/presentation/router/item_routes.dart';

class HomeRoutes {
  static final routes = <GoRoute>[
    GoRoute(
      path: HomeRouteLocations.home,
      parentNavigatorKey: navigatorKey,
      name: 'home',
      builder: HomePage.builder,
      routes: [
        ...DespensaRoutes.routes,
        ...ItemRoutes.routes,
      ],
    ),
  ];
}
