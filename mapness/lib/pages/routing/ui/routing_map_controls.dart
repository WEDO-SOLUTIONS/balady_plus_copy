import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/layers_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';

class RoutingMapControls extends ConsumerWidget {
  final double? bottomExtent;

  const RoutingMapControls({
    this.bottomExtent,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    const controlsHidden = false;

    return IgnorePointer(
      ignoring: controlsHidden,
      child: SafeArea(
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
                          FollowControl(
                            onlyFollowDirection: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: bottomExtent??74,
            ),
          ],
        ),
      ),
    );
  }
}
