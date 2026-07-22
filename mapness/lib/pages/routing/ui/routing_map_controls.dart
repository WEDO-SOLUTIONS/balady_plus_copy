import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/landing/compass_control.dart';
import 'package:mapness/widgets/landing/eta_sharing_control.dart';
import 'package:mapness/widgets/landing/follow_control.dart';
import 'package:mapness/widgets/landing/indoor_control.dart';
import 'package:mapness/widgets/landing/layers_control.dart';
import 'package:mapness/widgets/landing/traffic_control.dart';
import 'package:mapness/widgets/map_dimensions_control/dimension_contrtol.dart';
import 'package:mapness/widgets/weather/weather_control.dart';

import '../../../widgets/landing/map_attribution_label.dart';

class RoutingMapControls extends ConsumerWidget {
  const RoutingMapControls({
    @Deprecated('Please use sheetify outside property') this.bottomHeightNotifier,
    this.useSafeArea = true,
    this.onAddStop,
    super.key,
  });

  final ValueNotifier<double>? bottomHeightNotifier;
  final VoidCallback? onAddStop;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controlsMap = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WeatherControl(),
                      const Spacer(),
                      const IndoorControl(),
                      const Spacer(),
                      const EtaSharingControl(),
                      const Spacer(),
                      Row(
                        children: [
                          // todo: hide this button for now
                          // uikit.AppButton(
                          //   color: context.colors.backgroundSurface1,
                          //   iconColor: context.colors.foregroundSoft,
                          //   innerPadding: const EdgeInsets.symmetric(
                          //     horizontal: uikit.Spacing.$3x,
                          //   ),
                          //   onTap: () => context.router.push(NavigatorSettingsRoute()),
                          //   buttonColorScheme: uikit.ButtonColorScheme.neutral,
                          //   primaryIcon: uikit.SystemIcons.tuning,
                          // ),
                          if (onAddStop != null) ...[
                            const SizedBox(width: uikit.Spacing.$2x),
                            uikit.AppButton(
                              color: context.colors.onMapSurfaceOnMap,
                              iconColor: context.colors.foregroundSoft,
                              innerPadding: const EdgeInsets.symmetric(horizontal: uikit.Spacing.$3x),
                              primaryLabel: context.l10n.addStop,
                              onTap: onAddStop,
                              buttonColorScheme: uikit.ButtonColorScheme.neutral,
                              primaryIcon: Icons.add_location_rounded,
                              textColor: context.colors.foregroundDefault,
                            ),
                          ],
                        ],
                      ),
                      const MapAttributionLabel(),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const LayersControl(),
                      const SizedBox(height: uikit.Spacing.$2x),
                      const DimensionControl(),
                      const SizedBox(height: uikit.Spacing.$2x),
                      const Spacer(),
                      const CompassControl(),
                      uikit.Spacing.$2x.heightBox,
                      const FollowControl(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (bottomHeightNotifier != null)
          ValueListenableBuilder(
            valueListenable: bottomHeightNotifier!,
            builder: (context, value, _) => value.heightBox,
          ),
      ],
    );

    if (useSafeArea) {
      return SafeArea(bottom: false, child: controlsMap);
    }

    return controlsMap;
  }
}
