import 'package:balady_uikit/balady_uikit.dart' as ui_kit;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/app_features.dart';
import 'package:mapness/shared/ui/map_controls/map_controls_column.dart';
import 'package:mapness/widgets/landing/compass_control.dart';
import 'package:mapness/widgets/landing/follow_control.dart';
import 'package:mapness/widgets/landing/indoor_control.dart';
import 'package:mapness/widgets/landing/layers_control.dart';
import 'package:mapness/widgets/landing/traffic_control.dart';
import 'package:mapness/widgets/landing/zoom_control.dart';
import 'package:mapness/widgets/map_dimensions_control/dimension_contrtol.dart';

class PoiCardMapControls extends StatelessWidget {
  const PoiCardMapControls({super.key, this.objectIdForIndoorLevels});

  static const horizontalPadding = ui_kit.Spacing.$3x;
  static const topPadding = ui_kit.Spacing.$3x;
  static const bottomPadding = ui_kit.Spacing.$4x;
  final int? objectIdForIndoorLevels;

  static const padding = EdgeInsets.only(
    left: PoiCardMapControls.horizontalPadding,
    top: PoiCardMapControls.topPadding,
    right: PoiCardMapControls.horizontalPadding,
    bottom: PoiCardMapControls.bottomPadding,
  );

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.ltr,
    child: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: PoiCardMapControls.padding,
              child: Row(
                children: [
                  MapControlsColumn(
                    children: [
                      MapControlsItem(
                        priority: 50,
                        slot: MapControlsSlot.center,
                        child: IndoorControl(objectId: objectIdForIndoorLevels),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const MapControlsColumn(
                    children: [
                      MapControlsItem(priority: 80, child: LayersControl()),
                      MapControlsItem(priority: 60, child: DimensionControl()),
                      if (kDebugMode) MapControlsItem(priority: 10, slot: MapControlsSlot.center, child: ZoomControl()),
                      MapControlsItem(priority: 70, slot: MapControlsSlot.bottom, child: CompassControl()),
                      MapControlsItem(
                        priority: 100,
                        slot: MapControlsSlot.bottom,
                        child: Padding(
                          padding: EdgeInsets.only(top: ui_kit.Spacing.$3x - ui_kit.Spacing.$2x),
                          child: FollowControl(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
