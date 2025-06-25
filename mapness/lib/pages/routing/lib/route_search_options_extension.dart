import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';

extension RouteSearchOptionsMessageIcon on RouteSearchOptionsMessage {
  IconData icon(BuildContext context) => switch (this) {
        RouteSearchOptionsMessage.pedestrian =>
          Directionality.of(context) == TextDirection.ltr ? TransportIcons.pedestrianLTR : TransportIcons.pedestrianRTL,
        RouteSearchOptionsMessage.car => TransportIcons.car,
        RouteSearchOptionsMessage.publicTransport => TransportIcons.tram,
        _ => TransportIcons.car,
      };
}
