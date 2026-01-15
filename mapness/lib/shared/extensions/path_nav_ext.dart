import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/entities/path_nav/models/path_nav_message_state.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension ToUIKitMessage on PathNavMessageState {
  ManeuverMessageState toUIKit() => switch (this) {
        PathNavMessageState.gpsConnectionLost => ManeuverMessageState.error,
        PathNavMessageState.reroute => ManeuverMessageState.reroute,
      };

  String toMessage(AppLocalizations l10n) => switch (this) {
        PathNavMessageState.gpsConnectionLost => l10n.gpsLost,
        PathNavMessageState.reroute => l10n.routeResearch,
      };
}

extension ToUIKitModelManeuverInstruction on ManeuverInstruction {
  BaladyManeuverInstruction toUIKit() => switch (this) {
        ManeuverInstruction.none => BaladyManeuverInstruction.none,
        ManeuverInstruction.start => BaladyManeuverInstruction.start,
        ManeuverInstruction.finish => BaladyManeuverInstruction.finish,
        ManeuverInstruction.crossroad_straight => BaladyManeuverInstruction.crossroadStraight,
        ManeuverInstruction.crossroad_left => BaladyManeuverInstruction.crossroadLeft,
        ManeuverInstruction.crossroad_slightly_left => BaladyManeuverInstruction.crossroadSlightlyLeft,
        ManeuverInstruction.crossroad_sharply_left => BaladyManeuverInstruction.crossroadSharplyLeft,
        ManeuverInstruction.crossroad_right => BaladyManeuverInstruction.crossroadRight,
        ManeuverInstruction.crossroad_slightly_right => BaladyManeuverInstruction.crossroadSlightlyRight,
        ManeuverInstruction.crossroad_sharply_right => BaladyManeuverInstruction.crossroadSharplyRight,
        ManeuverInstruction.crossroad_keep_left => BaladyManeuverInstruction.crossroadKeepLeft,
        ManeuverInstruction.crossroad_keep_right => BaladyManeuverInstruction.crossroadKeepRight,
        ManeuverInstruction.roundabout_forward => BaladyManeuverInstruction.ringroadForward,
        ManeuverInstruction.roundabout_left_45 => BaladyManeuverInstruction.ringroadLeft45,
        ManeuverInstruction.roundabout_left_90 => BaladyManeuverInstruction.ringroadLeft90,
        ManeuverInstruction.roundabout_left_135 => BaladyManeuverInstruction.ringroadLeft135,
        ManeuverInstruction.roundabout_right_45 => BaladyManeuverInstruction.ringroadRight45,
        ManeuverInstruction.roundabout_right_90 => BaladyManeuverInstruction.ringroadRight90,
        ManeuverInstruction.roundabout_right_135 => BaladyManeuverInstruction.ringroadRight135,
        ManeuverInstruction.roundabout_backward => BaladyManeuverInstruction.ringroadBackward,
        ManeuverInstruction.roundabout_exit => BaladyManeuverInstruction.ringRoadExit,
        ManeuverInstruction.crossroad_uturn => BaladyManeuverInstruction.turnOverRightHand,
        ManeuverInstruction.uturn => BaladyManeuverInstruction.turnOverRightHand,
        ManeuverInstruction.road_crossing => BaladyManeuverInstruction.crossroadStraight,
      };
}
