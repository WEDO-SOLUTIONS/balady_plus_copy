import 'package:balady_uikit/balady_uikit.dart' as ui_kit;
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/indoor_control.dart';
import 'package:mapness/_features/landing/widgets/layers_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';

import 'package:mapness/shared/providers/app_features.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';

class PoiCardMapControls extends StatelessWidget {
  const PoiCardMapControls({super.key});

  static const horizontalPadding = ui_kit.Spacing.$3x;
  static const topPadding = ui_kit.Spacing.$3x;
  static const bottomPadding = ui_kit.Spacing.$4x;

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.ltr,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: PoiCardMapControls.horizontalPadding,
                    top: PoiCardMapControls.topPadding,
                    right: PoiCardMapControls.horizontalPadding,
                    bottom: PoiCardMapControls.bottomPadding,
                  ),
                  child: Row(
                    children: [
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IndoorControl(),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const LayersControl(),
                          const SizedBox(
                            height: 8,
                          ),
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
                          const Spacer(),
                          const ZoomControl(),
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
