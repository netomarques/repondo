import 'package:go_router/go_router.dart';
import 'package:repondo/features/despensa/presentation/pages/create_despensa_page.dart';
import 'package:repondo/features/despensa/presentation/router/despensa_route_locations.dart';

class DespensaRoutes {
  static final routes = <GoRoute>[
    GoRoute(
      path: DespensaRouteLocations.despensaCreatePath,
      name: DespensaRouteLocations.despensaCreateName,
      pageBuilder: CreateDespensaPage.pageBuilder,
    ),
  ];
}
