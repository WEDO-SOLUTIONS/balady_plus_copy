import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';

extension RouteSearchOptionsMessageIcon on RouteSearchOptionsMessage {
  IconData icon(BuildContext context) => switch (this) {
        RouteSearchOptionsMessage.pedestrian =>
          Directionality.of(context) == TextDirection.ltr ? PlacesIcons.runningLTR : PlacesIcons.runningRTL,
        RouteSearchOptionsMessage.car => TransportIcons.car,
        _ => TransportIcons.car,
      };
}
