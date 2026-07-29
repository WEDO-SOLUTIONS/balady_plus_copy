import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/pages/routing/ui/models/routing_details_ui_model.dart';
import 'package:mapness/pages/routing/ui/models/roution_details_ext.dart';
import 'package:mapness/pages/routing/ui/widgets/public_transport/dashed_line_painter.dart';
import 'package:mapness/pages/routing/ui/widgets/public_transport/routing_public_content_row.dart';
import 'package:mapness/pages/routing/ui/widgets/public_transport/routing_public_expandable.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/ar_functions.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';

part 'routing_public_tail_sector.dart';
part 'routing_public_pedestrian.dart';
part 'routing_public_metro.dart';

const _contentRowStartPadding = Spacing.$4x;
const _linePointCircleSize = 14.0;
const _connectedLineWidth = 2.0;

class RoutingPublicTransportContent extends StatelessWidget {
  final List<RouteDetailsPublicTransport>? data;
  final RouteParamsPointWithLabel? startPoint;
  final RouteParamsPointWithLabel? destination;

  const RoutingPublicTransportContent({
    required this.data,
    required this.startPoint,
    required this.destination,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final transports = data;
    if (transports == null) {
      return const SizedBox.shrink();
    }

    return ColoredBox(
      color: context.colors.backgroundSurface4,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.$4x),
        child: ContentWrapper(
          color: context.colors.backgroundSurface1,
          children: [
            RoutingPublicTailSector(
              data: transports,
              pointLabel: startPoint,
              type: PedestrianSectorType.first,
            ),
            ...filteredTransports().map(
              (e) => e.toWidget(
                context,
                lineColor: e is RouteDetailsPublicTransportMetro ? e.lineColor : null,
              ),
            ),
            RoutingPublicTailSector(
              data: transports,
              pointLabel: destination,
              type: PedestrianSectorType.last,
            ),
          ],
        ),
      ),
    );
  }

  List<RouteDetailsPublicTransport> filteredTransports() {
    final transports = data?.toList();
    if (transports == null) {
      return [];
    }
    if (transports.isEmpty) {
      return [];
    }

    if (transports.first is RouteDetailsPublicTransportPedestrian) {
      transports.removeAt(0);
    }

    if (transports.isEmpty) {
      return [];
    }

    if (transports.last is RouteDetailsPublicTransportPedestrian) {
      transports.removeLast();
    }

    return transports;
  }
}
