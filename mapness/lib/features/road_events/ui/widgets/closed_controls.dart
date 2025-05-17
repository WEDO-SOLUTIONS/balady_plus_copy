import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/widgets/landing/compass_control.dart';
import 'package:mapness/widgets/landing/complience_building_legend.dart';
import 'package:mapness/widgets/landing/follow_control.dart';
import 'package:mapness/widgets/landing/indoor_control.dart';
import 'package:mapness/widgets/landing/layers_control.dart';
import 'package:mapness/widgets/landing/traffic_control.dart';
import 'package:mapness/widgets/landing/zoom_control.dart';
import 'package:mapness/widgets/map_dimensions_control/dimension_contrtol.dart';

class ClosedControls extends ConsumerWidget {
  const ClosedControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SafeArea(
        bottom: false,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              top: 12,
              right: 12,
              bottom: 16,
            ),
            child: Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    IndoorControl(),
                    Spacer(),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const LayersControl(),
                    const SizedBox(height: 8),
                    const TrafficControl(),
                    const Spacer(),
                    const SizedBox(height: uikit.Spacing.$2x),
                    const DimensionContrtol(),
                    const ZoomControl(),
                    const Spacer(),
                    const CompassControl(),
                    const SizedBox(height: 8),
                    ComplianceBuildingLegend(),
                    const SizedBox(height: 8),
                    const FollowControl(),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
