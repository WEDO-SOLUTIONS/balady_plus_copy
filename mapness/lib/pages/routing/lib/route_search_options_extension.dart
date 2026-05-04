import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';

extension RouteSearchOptionsMessageIcon on RouteSearchOptionsMessage {
  IconData icon(
    BuildContext context, {
    required bool isOffline,
    required bool isPedestrianBlocked,
    required bool noPublicTransportData,
  }) {
    final ltr = Directionality.of(context) == TextDirection.ltr;

    IconData pedestrian({required bool error}) => ltr
        ? (error ? TransportIcons.pedestrianErrorLTR : TransportIcons.pedestrianLTR)
        : (error ? TransportIcons.pedestrianErrorRTL : TransportIcons.pedestrianRTL);

    if (this == RouteSearchOptionsMessage.pedestrian) {
      return pedestrian(error: isOffline || isPedestrianBlocked);
    } else if (this == RouteSearchOptionsMessage.car) {
      return isOffline ? TransportIcons.carError : TransportIcons.car;
    } else if (this == RouteSearchOptionsMessage.publicTransport) {
      return (isOffline || noPublicTransportData) ? TransportIcons.tramError : TransportIcons.tram;
    }

    return TransportIcons.car;
  }
}
