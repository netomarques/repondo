import 'package:go_router/go_router.dart';
import 'package:repondo/features/auth/presentation/router/auth_routes.dart';
import 'package:repondo/features/home/presentation/router/home_routes.dart';

class AppRoutes {
  static final routes = <GoRoute>[
    ...AuthRoutes.routes,
    ...HomeRoutes.routes,
  ];
}
