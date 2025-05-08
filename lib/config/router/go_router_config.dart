import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:repondo/config/navigator/navigator_key.dart';
import 'package:repondo/config/router/app_routes.dart';
import 'package:repondo/config/router/go_router_redirect_provider.dart';
import 'package:repondo/features/auth/presentation/exports.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'go_router_config.g.dart';

/// Provider que configura o GoRouter com navegação reativa e redirecionamento controlado.
/// Mantém-se vivo (keepAlive) para não ser descartado da memória entre navegações.
@Riverpod(keepAlive: true)
GoRouter goRouterConfig(Ref ref) {
  return GoRouter(
    navigatorKey: navigatorKey, // Necessário para chamadas globais de navegação
    initialLocation: AuthRouteLocations.splash, // Tela inicial padrão (Splash)
    debugLogDiagnostics: true, // Habilita logs de navegação para debug
    routes: AppRoutes.routes, // Todas as rotas definidas centralmente
    redirect: ref.watch(
        goRouterRedirectProvider), // Redirecionamento reativo baseado no estado da autenticação
  );
}
