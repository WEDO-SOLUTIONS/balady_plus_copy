import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/bus_departures/model.dart';

import 'poi_lines_bus.dart';

class PoiLinesContainer extends StatelessWidget {
  final TransitSystem? model;
  final bool isShuttle;

  const PoiLinesContainer({this.model, this.isShuttle = false, super.key});

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Spacing.$4x).copyWith(bottom: Spacing.$4x),
      padding: const EdgeInsets.all(Spacing.$4x),
      decoration: BoxDecoration(
        color: context.colors.backgroundSurface1,
        borderRadius: BorderRadius.circular(Spacing.$4x),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                model?.id == 'haram_shuttle' ? PlacesIcons.qibla : TransportIcons.bus,
                size: 24,
                color: context.colors.foregroundDefault,
              ),
              Spacing.$3x.widthBox,
              Text(
                model!.label,
                style: context.textStyles.bodyLargeMedium.copyWith(
                  color: context.colors.foregroundDefault,
                ),
              ),
            ],
          ),
          Spacing.$4x.heightBox,
          ...List.generate(
            model!.routes.length,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: model!.routes.length - 1 == index ? 0 : Spacing.$2x),
              child: PoiLinesMakkahBus(
                routeInfo: model!.routes[index],
                isShuttle: isShuttle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
