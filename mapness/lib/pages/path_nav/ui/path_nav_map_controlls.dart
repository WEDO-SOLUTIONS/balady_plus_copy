import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/layers_control.dart';
import 'package:mapness/shared/providers/app_features.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';

class PathNavMapControlls extends StatelessWidget {
  const PathNavMapControlls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          top: 12,
          right: 12,
          bottom: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
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
            const SizedBox(
              height: 8,
            ),
            const FollowControl(),
          ],
        ),
      ),
    );
  }
}
