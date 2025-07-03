import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mapness/pages/routing/ui/models/routing_details_ui_model.dart';
import 'package:mapness/pages/routing/ui/widgets/routing_collapsible_list.dart';
import 'package:mapness/pages/routing/ui/widgets/routing_pedestrian.dart';

extension RouteDetailsPublicTransportExt on RouteDetailsPublicTransport {
  Widget toWidget(BuildContext context) => switch (this) {
        RouteDetailsPublicTransportPedestrian() =>
          RoutingPedestrian(data: this as RouteDetailsPublicTransportPedestrian),
        RouteDetailsPublicTransportMetro() => RoutingCollapsibleList(
            stations: (this as RouteDetailsPublicTransportMetro).routeParts.map((e) => e.stations).flattened.toList()),
      };
}
