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
    ManeuverInstruction.crossroadStraight => BaladyManeuverInstruction.crossroadStraight,
    ManeuverInstruction.crossroadLeft => BaladyManeuverInstruction.crossroadLeft,
    ManeuverInstruction.crossroadSlightlyLeft => BaladyManeuverInstruction.crossroadSlightlyLeft,
    ManeuverInstruction.crossroadSharplyLeft => BaladyManeuverInstruction.crossroadSharplyLeft,
    ManeuverInstruction.crossroadRight => BaladyManeuverInstruction.crossroadRight,
    ManeuverInstruction.crossroadSlightlyRight => BaladyManeuverInstruction.crossroadSlightlyRight,
    ManeuverInstruction.crossroadSharplyRight => BaladyManeuverInstruction.crossroadSharplyRight,
    ManeuverInstruction.crossroadKeepLeft => BaladyManeuverInstruction.crossroadKeepLeft,
    ManeuverInstruction.crossroadKeepRight => BaladyManeuverInstruction.crossroadKeepRight,
    ManeuverInstruction.roundaboutForward => BaladyManeuverInstruction.ringroadForward,
    ManeuverInstruction.roundaboutLeft45 => BaladyManeuverInstruction.ringroadLeft45,
    ManeuverInstruction.roundaboutLeft90 => BaladyManeuverInstruction.ringroadLeft90,
    ManeuverInstruction.roundaboutLeft135 => BaladyManeuverInstruction.ringroadLeft135,
    ManeuverInstruction.roundaboutRight45 => BaladyManeuverInstruction.ringroadRight45,
    ManeuverInstruction.roundaboutRight90 => BaladyManeuverInstruction.ringroadRight90,
    ManeuverInstruction.roundaboutRight135 => BaladyManeuverInstruction.ringroadRight135,
    ManeuverInstruction.roundaboutBackward => BaladyManeuverInstruction.ringroadBackward,
    ManeuverInstruction.roundaboutExit => BaladyManeuverInstruction.ringRoadExit,
    ManeuverInstruction.crossroadUturn => BaladyManeuverInstruction.turnOverRightHand,
    ManeuverInstruction.uturn => BaladyManeuverInstruction.turnOverRightHand,
    ManeuverInstruction.roadCrossing => BaladyManeuverInstruction.crossroadStraight,
  };
}
