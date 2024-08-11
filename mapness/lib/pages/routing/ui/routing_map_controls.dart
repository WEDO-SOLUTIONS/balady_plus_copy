import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/indoor_control.dart';
import 'package:mapness/_features/landing/widgets/layers_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';

class RoutingMapControls extends ConsumerWidget {
  const RoutingMapControls({
    this.bottomExtent,
    super.key,
  });
  final double? bottomExtent;

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
                          Spacer(),
                          IndoorControl(),
                          Spacer(),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          LayersControl(),
                          SizedBox(height: 8),
                          TrafficControl(),
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
            SizedBox(
              height: bottomExtent ?? 74,
            ),
          ],
        ),
      );
}
