import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';

extension RouteSearchOptionsMessageIcon on RouteSearchOptionsMessage {
  IconData icon(BuildContext context, List<BriefPublicTransportModel> list, {required bool errorPedestrian}) => switch (this) {
        RouteSearchOptionsMessage.pedestrian =>
          Directionality.of(context) == TextDirection.ltr ? errorPedestrian
                ? TransportIcons.pedestrianErrorLTR : TransportIcons.pedestrianLTR : errorPedestrian ? TransportIcons.pedestrianErrorRTL : TransportIcons.pedestrianRTL,
        RouteSearchOptionsMessage.car => TransportIcons.car,
        RouteSearchOptionsMessage.publicTransport => list.isEmpty ? TransportIcons.tramError : TransportIcons.tram,
        _ => TransportIcons.car,
      };
}
