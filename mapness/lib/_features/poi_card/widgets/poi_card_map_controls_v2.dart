import 'package:balady_uikit/balady_uikit.dart' as ui_kit;
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/indoor_control.dart';
import 'package:mapness/_features/landing/widgets/layers_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/shared/providers/app_features.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';

class PoiCardMapControlsV2 extends StatelessWidget {
  const PoiCardMapControlsV2({
    required this.hideControls,
    required this.bottomSheetHeight,
    super.key,
  });

  final ValueListenable<bool> hideControls;
  final ValueListenable<double> bottomSheetHeight;

  static const horizontalPadding = ui_kit.Spacing.$3x;
  static const topPadding = ui_kit.Spacing.$3x;
  static const bottomPadding = ui_kit.Spacing.$4x;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: hideControls,
        builder: (context, hideControls, child) {
          if (child == null) {
            return const SizedBox.shrink();
          }
          return Visibility(
            visible: hideControls,
            child: child,
          );
        },
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: PoiCardMapControlsV2.horizontalPadding,
                      top: PoiCardMapControlsV2.topPadding,
                      right: PoiCardMapControlsV2.horizontalPadding,
                      bottom: PoiCardMapControlsV2.bottomPadding,
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
                ValueListenableBuilder<double>(
                    valueListenable: bottomSheetHeight,
                    builder: (_, height, __) => SizedBox(
                          height: (height + bottomPadding).clamp(
                            0,
                            MediaQuery.sizeOf(context).height,
                          ),
                        )),
              ],
            ),
          ),
        ),
      );
}
