import 'package:flutter/material.dart';
import 'package:repondo/config/router/app_route_locations.dart';

@immutable
class DespensaRouteLocations {
  const DespensaRouteLocations._();

  static const String despensaRoot = 'despensa';

  static const String despensaCreatePath = '$despensaRoot/create';
  static const String despensaCreateFullPath =
      '${AppRouteLocations.authAreaRoot}}/$despensaRoot/create';
  static const String despensaCreateName = 'despensa-create';
}
