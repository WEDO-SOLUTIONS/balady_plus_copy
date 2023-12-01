import 'package:flutter/material.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/layers_control.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';

class PathNavMapControlls extends StatelessWidget {
  const PathNavMapControlls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.only(
          left: 12,
          top: 12,
          right: 12,
          bottom: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            LayersControl(),
            SizedBox(
              height: 8,
            ),
            TrafficControl(),
            Spacer(),
            ZoomControl(),
            Spacer(),
            CompassControl(),
            SizedBox(
              height: 8,
            ),
            FollowControl(),
          ],
        ),
      ),
    );
  }
}
