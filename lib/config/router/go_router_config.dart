import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:repondo/config/navigator/navigator_key.dart';
import 'package:repondo/config/router/app_routes.dart';
import 'package:repondo/config/router/redirect_handler.dart';
import 'package:repondo/features/auth/presentation/exports.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'go_router_config.g.dart';

@Riverpod(keepAlive: true)
GoRouter goRouterConfig(Ref ref) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AuthRouteLocations.splash,
    debugLogDiagnostics: true,
    routes: AppRoutes.routes,
    redirect: ref.watch(redirectHandlerProvider),
  );
}
