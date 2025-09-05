import 'package:balady_uikit/balady_uikit.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mapness/pages/routing/ui/models/routing_details_ui_model.dart';
import 'package:mapness/pages/routing/ui/widgets/public_transport/dashed_line_painter.dart';
import 'package:mapness/pages/routing/ui/widgets/public_transport/routing_public_transport_content.dart';

extension RouteDetailsPublicTransportExt on RouteDetailsPublicTransport {
  Widget toWidget(BuildContext context, {Color? lineColor}) => switch (this) {
        RouteDetailsPublicTransportPedestrian() => Row(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 15 + 14 / 2 + 1),
                child: CustomPaint(
                  painter: DashedLinePainter(),
                  size: const Size(2, 80),
                ),
              ),
              const SizedBox(width: Spacing.$3x),
              RoutingPublicPedestrian(
                data: this as RouteDetailsPublicTransportPedestrian,
                horizontalPadding: 0,
                topPadding: Spacing.$3x,
                bottomPadding: Spacing.$3x,
              ),
            ],
          ),
        RouteDetailsPublicTransportMetro() => RoutingPublicMetro(
            stations: (this as RouteDetailsPublicTransportMetro).routeParts.map((e) => e.stations).flattened.toList(),
            lineName: (this as RouteDetailsPublicTransportMetro).lineName,
            lineColor: lineColor,
          ),
      };
}
