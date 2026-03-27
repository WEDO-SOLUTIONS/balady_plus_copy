import 'package:balady_uikit/balady_uikit.dart' as ui_kit;
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/app_features.dart';
import 'package:mapness/widgets/landing/compass_control.dart';
import 'package:mapness/widgets/landing/follow_control.dart';
import 'package:mapness/widgets/landing/indoor_control.dart';
import 'package:mapness/widgets/landing/layers_control.dart';
import 'package:mapness/widgets/landing/traffic_control.dart';
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IndoorControl(objectId: objectIdForIndoorLevels),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LayersControl(),
                      const SizedBox(height: ui_kit.Spacing.$2x),
                      Consumer(
                        builder: (context, ref, _) {
                          final navi = ref.watch(appFeaturesProvider);
                          return Visibility(
                            visible: navi.naviEnabled,
                            replacement: const SizedBox.square(
                              dimension: 28,
                            ),
                            child: const TrafficControl(),
                          );
                        },
                      ),
                      const SizedBox(height: ui_kit.Spacing.$2x),
                      const DimensionControl(),
                      const Spacer(),
                      const CompassControl(),
                      ui_kit.Spacing.$3x.heightBox,
                      const FollowControl(),
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
