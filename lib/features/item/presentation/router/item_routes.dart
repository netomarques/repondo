import 'package:go_router/go_router.dart';
import 'package:repondo/features/item/domain/entities/item.dart';
import 'package:repondo/features/item/presentation/pages/exports.dart';
import 'package:repondo/features/item/presentation/router/item_route_locations.dart';

class ItemRoutes {
  static final routes = <GoRoute>[
    GoRoute(
      path: ItemRouteLocations.itemCreatePath,
      name: ItemRouteLocations.itemCreateName,
      pageBuilder: CreateItemPage.pageBuilder,
    ),
    GoRoute(
      path: ItemRouteLocations.itemUpdatePath,
      name: ItemRouteLocations.itemUpdateName,
      pageBuilder: (context, state) {
        final item = state.extra as Item;

        return UpdateItemPage.pageBuilder(
          context,
          state,
          item,
        );
      },
    ),
  ];
}
