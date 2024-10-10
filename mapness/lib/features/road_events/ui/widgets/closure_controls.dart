import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/complience_building_legend.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/indoor_control.dart';
import 'package:mapness/_features/landing/widgets/layers_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';

class ClosureControls extends ConsumerWidget {
  const ClosureControls({super.key});

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
