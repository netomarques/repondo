import 'package:flutter/material.dart';
import 'package:repondo/config/router/app_route_locations.dart';

@immutable
class ItemRouteLocations {
  const ItemRouteLocations._();

  static const String itemRoot = 'item';

  static const String itemCreatePath = '$itemRoot/create';
  static const String itemCreateFullPath =
      '${AppRouteLocations.authAreaRoot}}/$itemRoot/create';
  static const String itemCreateName = 'item-create';
}
