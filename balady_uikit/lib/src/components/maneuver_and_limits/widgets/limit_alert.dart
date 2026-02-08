import 'package:balady_uikit/src/components/maneuver_and_limits/models/path_nav_speed_info.dart';
import 'package:balady_uikit/src/components/maneuver_and_limits/widgets/speed_limit.dart';
import 'package:balady_uikit/src/components/maneuver_and_limits/widgets/speedometr.dart';
import 'package:flutter/material.dart';

/// [LimitAlert] is a widget that shows the speed limit and the current speed
/// of the vehicle.
/// If the speed limit is exceeded, the speed limit will be highlighted in red.
/// The seed limit widget will be highlighted in red only if the [speedExceed] parameter is true.
///
/// Example:
/// ```dart
/// LimitAlert(info: LimitsModel(speed: 60, speedLimit: 50, speedExceed: true))
/// ```
///
/// See also:
/// * [Figma]
/// https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=3574%3A43095&mode=design&t=RLpSekxOdSEpOaqf-1
class LimitAlert extends StatelessWidget {
  /// The size of the widget.
  static const double size = 92;

  /// Constructor
  const LimitAlert({
    required this.info,
    required this.hideSpeedLimit,
    super.key,
  });

  /// The information about the speed limits and the speed of the vehicle.
  final LimitsModel info;
  final bool hideSpeedLimit;

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            /// speed
            Positioned(
              bottom: 0,
              left: isArabic ? null : 0,
              right: isArabic ? 0 : null,
              child: Speedometr(info: info),
            ),

            /// speed limit
            if (!hideSpeedLimit)
              Positioned(
                top: 0,
                right: isArabic ? null : 0,
                left: isArabic ? 0 : null,
                child: SpeedLimit(info: info),
              ),
          ],
        ),
      ),
    );
  }
}
