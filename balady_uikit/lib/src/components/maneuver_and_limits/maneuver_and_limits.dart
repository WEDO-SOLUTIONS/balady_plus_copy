import 'package:balady_uikit/src/components/maneuver_and_limits/models/maneuver_message_model.dart';
import 'package:balady_uikit/src/components/maneuver_and_limits/models/maneuver_model.dart';
import 'package:balady_uikit/src/components/maneuver_and_limits/models/path_nav_speed_info.dart';
import 'package:balady_uikit/src/components/maneuver_and_limits/widgets/limit_alert.dart';
import 'package:balady_uikit/src/components/maneuver_and_limits/widgets/maneuver.dart';
import 'package:balady_uikit/src/components/maneuver_and_limits/widgets/maneuver_alert.dart';
import 'package:flutter/material.dart';

/// [BaladyManeuverAndLimit] is a widget that shows the maneuver and the speed limits.
/// This is as general widget that combines the [BaladyManeuverAlert] and the [LimitAlert] widgets.
/// The [BaladyManeuverAlert] will be shown if the [maneuver] is not null.
/// The [BaladyMessageWidget] will be shown if the [message] is not null.
/// The [LimitAlert] will be shown if the [info] is not null or the [isPedestrian] is false.
///
/// Example:
/// ```dart
/// BaladyManeuverAndLimit(
///   isPedestrian: false,
///   speedInfo: LimitsModel(
///     direction: NaviCameraDirection.left,
///     speed: 60,
///     speedLimit: 50,
///     speedExceed: true,
///   ),
/// maneuver: BaladyManeuverModel(
///   instruction: BaladyManeuverInstruction.crossroadLeft,
///   roadName: 'Elm Street',
///   distance: '100',
///   unit: 'm',
/// ),
/// )
/// ```
///
/// See also:
/// * [Figma]
/// https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=3574%3A43095&mode=design&t=RLpSekxOdSEpOaqf-1
class BaladyManeuverAndLimit extends StatelessWidget {
  final bool isPedestrian;
  final bool hideSpeedLimit;
  final LimitsModel? speedInfo;
  final BaladyManeuverModel? maneuver;
  final ManeuverMessageModel? message;
  const BaladyManeuverAndLimit({
    required this.isPedestrian,
    this.hideSpeedLimit = false,
    super.key,
    this.speedInfo,
    this.maneuver,
    this.message,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BaladyManeuver(
              maneuver: maneuver,
              message: message,
            ),
            Builder(
              builder: (context) {
                if (isPedestrian || speedInfo == null) {
                  return const Spacer();
                }
                return LimitAlert(
                  hideSpeedLimit: hideSpeedLimit,
                  info: speedInfo!,
                );
              },
            ),
          ],
        ),
      );
}
