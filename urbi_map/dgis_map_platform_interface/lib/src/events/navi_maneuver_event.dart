abstract class NaviManeuverEvent {
  const NaviManeuverEvent();
}

class ManeuverEventHidden extends NaviManeuverEvent {
  const ManeuverEventHidden();

  static const name = "maneuverEvent";
}

class ManeuverEvent extends NaviManeuverEvent {
  const ManeuverEvent({
    required this.distance,
    required this.unit,
    required this.roadName,
    required this.instruction,
  });

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
  crossroad_straight,
  crossroad_slightly_left,
  crossroad_left,
  crossroad_sharply_left,
  crossroad_slightly_right,
  crossroad_right,
  crossroad_sharply_right,
  crossroad_keep_left,
  crossroad_keep_right,
  crossroad_uturn,
  roundabout_forward,
  roundabout_left_45,
  roundabout_left_90,
  roundabout_left_135,
  roundabout_right_45,
  roundabout_right_90,
  roundabout_right_135,
  roundabout_backward,
  roundabout_exit,
  uturn,
  road_crossing;

  static ManeuverInstruction fromString(String s) {
    switch (s.toLowerCase()) {
      case "none":
        return ManeuverInstruction.none;
      case "start":
        return ManeuverInstruction.start;
      case "finish":
        return ManeuverInstruction.finish;
      case "crossroad_straight":
        return ManeuverInstruction.crossroad_straight;
      case "crossroad_slightly_left":
        return ManeuverInstruction.crossroad_slightly_left;
      case "crossroad_left":
        return ManeuverInstruction.crossroad_left;
      case "crossroad_sharply_left":
        return ManeuverInstruction.crossroad_sharply_left;
      case "crossroad_slightly_right":
        return ManeuverInstruction.crossroad_slightly_right;
      case "crossroad_right":
        return ManeuverInstruction.crossroad_right;
      case "crossroad_sharply_right":
        return ManeuverInstruction.crossroad_sharply_right;
      case "crossroad_keep_left":
        return ManeuverInstruction.crossroad_keep_left;
      case "crossroad_keep_right":
        return ManeuverInstruction.crossroad_keep_right;
      case "crossroad_uturn":
        return ManeuverInstruction.crossroad_uturn;
      case "roundabout_forward":
        return ManeuverInstruction.roundabout_forward;
      case "roundabout_left_45":
        return ManeuverInstruction.roundabout_left_45;
      case "roundabout_left_90":
        return ManeuverInstruction.roundabout_left_90;
      case "roundabout_left_135":
        return ManeuverInstruction.roundabout_left_135;
      case "roundabout_right_45":
        return ManeuverInstruction.roundabout_right_45;
      case "roundabout_right_90":
        return ManeuverInstruction.roundabout_right_90;
      case "roundabout_right_135":
        return ManeuverInstruction.roundabout_right_135;
      case "roundabout_backward":
        return ManeuverInstruction.roundabout_backward;
      case "roundabout_exit":
        return ManeuverInstruction.roundabout_exit;
      case "uturn":
        return ManeuverInstruction.uturn;
      case "road_crossing":
        return ManeuverInstruction.road_crossing;
      default:
        throw Exception("Unknown instruction type: $s");
    }
  }

  /// Non-throwing variant for event-channel payloads: an unknown or missing
  /// instruction is a display no-op, not an error worth reporting per event.
  static ManeuverInstruction? tryFromString(String s) {
    try {
      return ManeuverInstruction.fromString(s);
    } on Exception {
      return null;
    }
  }
}
