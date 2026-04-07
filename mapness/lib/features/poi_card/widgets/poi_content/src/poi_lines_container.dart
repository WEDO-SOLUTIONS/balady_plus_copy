import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/bus_departures/model.dart';

import 'poi_lines_bus.dart';

class PoiLinesContainer extends StatelessWidget {
  final TransitSystem? model;

  const PoiLinesContainer({this.model, super.key});

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
          Padding(
            padding: const EdgeInsetsDirectional.only(start: Spacing.$4x),
            child: Row(
              children: [
                Icon(
                   model!.id=='makkah_bus'?PlacesIcons.qibla:Icons.directions_bus_filled_sharp,
                  color: context.colors.foregroundDefault,
                  size: Spacing.$5x,
                ),
                Spacing.$1x.widthBox,
                Text(
                  model!.label,
                  style: context.textStyles.bodyLargeMedium.copyWith(
                    color: context.colors.foregroundDefault,
                  ),
                ),
              ],
            ),
          ),
          Spacing.$4x.heightBox,
          ...List.generate(
            model!.routes.length,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: model!.routes.length-1== index? 0 : Spacing.$2x),
              child: PoiLinesMakkahBus(routeInfo: model!.routes[index]),
            ),
          ),
        ],
      ),
    );
  }
}
