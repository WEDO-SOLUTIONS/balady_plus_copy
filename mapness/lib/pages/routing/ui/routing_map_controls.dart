import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/widgets/landing/compass_control.dart';
import 'package:mapness/widgets/landing/eta_sharing_control.dart';
import 'package:mapness/widgets/landing/follow_control.dart';
import 'package:mapness/widgets/landing/indoor_control.dart';
import 'package:mapness/widgets/landing/layers_control.dart';
import 'package:mapness/widgets/landing/traffic_control.dart';
import 'package:mapness/widgets/landing/zoom_control.dart';
import 'package:mapness/widgets/map_dimensions_control/dimension_contrtol.dart';
import 'package:mapness/widgets/weather/weather_control.dart';

class RoutingMapControls extends ConsumerWidget {
  const RoutingMapControls({
    this.bottomHeightNotifier,
    super.key,
  });

  final ValueNotifier<double>? bottomHeightNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) => SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Directionality(
              textDirection: TextDirection.ltr,
              child: Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 12,
                    top: 12,
                    right: 12,
                    bottom: 16,
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WeatherControl(),
                          Spacer(),
                          IndoorControl(),
                          Spacer(),
                          EtaSharingControl(),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          LayersControl(),
                          SizedBox(height: 8),
                          TrafficControl(),
                          SizedBox(height: uikit.Spacing.$2x),
                          DimensionContrtol(),
                          Spacer(),
                          ZoomControl(),
                          Spacer(),
                          CompassControl(),
                          SizedBox(height: 8),
                          FollowControl(),
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
            if (bottomHeightNotifier == null) uikit.Spacing.$3x.heightBox
          ],
        ),
      );
}
