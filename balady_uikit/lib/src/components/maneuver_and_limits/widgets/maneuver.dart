import 'package:balady_uikit/src/components/maneuver_and_limits/models/maneuver_message_model.dart';
import 'package:balady_uikit/src/components/maneuver_and_limits/models/maneuver_model.dart';
import 'package:balady_uikit/src/components/maneuver_and_limits/widgets/maneuver_alert.dart';
import 'package:balady_uikit/src/components/maneuver_and_limits/widgets/maneuver_message.dart';
import 'package:flutter/material.dart';

/// [BaladyManeuver] is a widget that shows the maneuver or a message.
///
/// The [BaladyManeuverMessage] will be shown if the [message] is not null.
///
/// The [BaladyManeuverAlert] will be shown if the [maneuver] is not null and the messege is null.
///
/// Example:
/// ```dart
/// BaladyManeuver(
///  maneuver: BaladyManeuverModel(
///   instruction: BaladyManeuverInstruction.left,
///   roadName: 'Elm Street',
///   distance: '100',
///   unit: 'm',
///  ),
/// )
/// ```
///
/// See also:
/// * [Figma]
/// https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=3574%3A43095&mode=design&t=RLpSekxOdSEpOaqf-1
class BaladyManeuver extends StatelessWidget {
  final BaladyManeuverModel? maneuver;
  final ManeuverMessageModel? message;
  const BaladyManeuver({super.key, this.maneuver, this.message});

  @override
  Widget build(BuildContext context) {
    if (message != null) {
      return BaladyManeuverMessage(
        message: message!,
      );
    }
    if (maneuver != null) {
      return BaladyManeuverAlert(
        maneuver: maneuver!,
      );
    }
    return const SizedBox.shrink();
  }
}
