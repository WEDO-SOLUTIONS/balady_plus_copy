import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/src/components/maneuver_and_limits/models/path_nav_speed_info.dart';
import 'package:balady_uikit/src/layouts/shadows.dart';
import 'package:flutter/material.dart';

/// [Speedometr] is a widget that shows the speed of the vehicle.
/// It is a part of the [LimitAlert] widget.
///
/// Example:
/// ```dart
/// Speedometr(info: LimitsModel(
///    direction: NaviCameraDirection.front,
///    speed: 60,
///    speedLimit: 50,
///    speedExceed: true,
/// ))
/// ```
///
/// See also:
/// * [Figma]
/// https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=3574%3A43095&mode=design&t=RLpSekxOdSEpOaqf-1
class Speedometr extends StatelessWidget {
  /// The information about the speed limits and the speed of the vehicle.
  final LimitsModel info;

  /// Different sizes because we need to show a shadow around the widget.
  /// For that we need a gap between the widget and the borders of container incide which is it.
  static const double generalSize = 64;
  static const double innerSize = 54;

  /// Constructor
  const Speedometr({
    required this.info,
    super.key,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: generalSize,
        height: generalSize,
        child: SizedBox(
          width: innerSize,
          height: innerSize,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              shape: const CircleBorder(),
              color: context.colors.onmapSurfaceOnMap,
              shadows: Shadows.m,
            ),
            child: Center(
              child: Baseline(
                baselineType: TextBaseline.alphabetic,
                baseline: context.textStyles.h1SemiBold.fontSize!,
                child: Text(
                  '${info.speed}',
                  style: context.textStyles.h1SemiBold.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ),
      );
}
