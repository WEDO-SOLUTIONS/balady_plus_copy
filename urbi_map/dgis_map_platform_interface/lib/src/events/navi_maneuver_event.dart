abstract class NaviManeuverEvent {
  const NaviManeuverEvent();
}

class ManeuverEventHidden extends NaviManeuverEvent {
  const ManeuverEventHidden();

  static const name = "maneuverEvent";
}

class ManeuverEvent extends NaviManeuverEvent {
  const ManeuverEvent({required this.distance, required this.unit, required this.roadName, required this.instruction});

  final String distance;
  final String unit;
  final String roadName;
  final ManeuverInstruction instruction;

  static const name = "maneuverEvent";
}

abstract class ManeuverAdditionalEvent extends NaviManeuverEvent {
  const ManeuverAdditionalEvent();

  static const name = "maneuverAdditionalEvent";
}

class ManeuverAdditionalEventExit extends ManeuverAdditionalEvent {
  const ManeuverAdditionalEventExit(this.value);

  final String value;
}

class ManeuverAdditionalEventWithIcon extends ManeuverAdditionalEvent {
  const ManeuverAdditionalEventWithIcon(this.instruction);

  final ManeuverInstruction instruction;
}

class ManeuverAdditionalEventHidden extends ManeuverAdditionalEvent {
  const ManeuverAdditionalEventHidden();
}

enum ManeuverInstruction {
  none,
  start,
  finish,
  crossroadStraight,
  crossroadSlightlyLeft,
  crossroadLeft,
  crossroadSharplyLeft,
  crossroadSlightlyRight,
  crossroadRight,
  crossroadSharplyRight,
  crossroadKeepLeft,
  crossroadKeepRight,
  crossroadUturn,
  roundaboutForward,
  roundaboutLeft45,
  roundaboutLeft90,
  roundaboutLeft135,
  roundaboutRight45,
  roundaboutRight90,
  roundaboutRight135,
  roundaboutBackward,
  roundaboutExit,
  uturn,
  roadCrossing;

  static ManeuverInstruction fromString(String s) {
    switch (s.toLowerCase()) {
      case "none":
        return ManeuverInstruction.none;
      case "start":
        return ManeuverInstruction.start;
      case "finish":
        return ManeuverInstruction.finish;
      case "crossroad_straight":
        return ManeuverInstruction.crossroadStraight;
      case "crossroad_slightly_left":
        return ManeuverInstruction.crossroadSlightlyLeft;
      case "crossroad_left":
        return ManeuverInstruction.crossroadLeft;
      case "crossroad_sharply_left":
        return ManeuverInstruction.crossroadSharplyLeft;
      case "crossroad_slightly_right":
        return ManeuverInstruction.crossroadSlightlyRight;
      case "crossroad_right":
        return ManeuverInstruction.crossroadRight;
      case "crossroad_sharply_right":
        return ManeuverInstruction.crossroadSharplyRight;
      case "crossroad_keep_left":
        return ManeuverInstruction.crossroadKeepLeft;
      case "crossroad_keep_right":
        return ManeuverInstruction.crossroadKeepRight;
      case "crossroad_uturn":
        return ManeuverInstruction.crossroadUturn;
      case "roundabout_forward":
        return ManeuverInstruction.roundaboutForward;
      case "roundabout_left_45":
        return ManeuverInstruction.roundaboutLeft45;
      case "roundabout_left_90":
        return ManeuverInstruction.roundaboutLeft90;
      case "roundabout_left_135":
        return ManeuverInstruction.roundaboutLeft135;
      case "roundabout_right_45":
        return ManeuverInstruction.roundaboutRight45;
      case "roundabout_right_90":
        return ManeuverInstruction.roundaboutRight90;
      case "roundabout_right_135":
        return ManeuverInstruction.roundaboutRight135;
      case "roundabout_backward":
        return ManeuverInstruction.roundaboutBackward;
      case "roundabout_exit":
        return ManeuverInstruction.roundaboutExit;
      case "uturn":
        return ManeuverInstruction.uturn;
      case "road_crossing":
        return ManeuverInstruction.roadCrossing;
      default:
        throw Exception("Unknown instruction type: $s");
    }
  }
}
