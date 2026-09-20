/// Base class for what navigation shows in the maneuver banner: the next
/// turn, or an instruction to hide the banner.
abstract class NaviManeuverEvent {
  /// Creates the base event.
  const NaviManeuverEvent();
}

/// Tells the banner there is no maneuver to show.
class ManeuverEventHidden extends NaviManeuverEvent {
  /// Creates the event.
  const ManeuverEventHidden();

  /// Name of the platform channel event this is decoded from.
  static const name = "maneuverEvent";
}

/// Describes the next turn: how far away it is, what it is, and the road it
/// leads onto.
class ManeuverEvent extends NaviManeuverEvent {
  /// Creates the maneuver description.
  const ManeuverEvent({required this.distance, required this.unit, required this.roadName, required this.instruction});

  /// Distance to the turn, already formatted by the native side.
  final String distance;

  /// Unit [distance] is expressed in, e.g. "m" or "km".
  final String unit;

  /// Road the turn leads onto.
  final String roadName;

  /// Which turn to make.
  final ManeuverInstruction instruction;

  /// Name of the platform channel event this is decoded from.
  static const name = "maneuverEvent";
}

/// Base class for the secondary line of the maneuver banner, which follows
/// the main turn with an exit number or a second turn.
abstract class ManeuverAdditionalEvent extends NaviManeuverEvent {
  /// Creates the base event.
  const ManeuverAdditionalEvent();

  /// Name of the platform channel event these are decoded from.
  static const name = "maneuverAdditionalEvent";
}

/// Secondary line naming the exit to take.
class ManeuverAdditionalEventExit extends ManeuverAdditionalEvent {
  /// Creates the event for the given exit.
  const ManeuverAdditionalEventExit(this.value);

  /// Exit label as the native side formatted it.
  final String value;
}

/// Secondary line showing a second turn that follows the first.
class ManeuverAdditionalEventWithIcon extends ManeuverAdditionalEvent {
  /// Creates the event for the following turn.
  const ManeuverAdditionalEventWithIcon(this.instruction);

  /// The turn that comes after the one in the main line.
  final ManeuverInstruction instruction;
}

/// Tells the banner there is no secondary line to show.
class ManeuverAdditionalEventHidden extends ManeuverAdditionalEvent {
  /// Creates the event.
  const ManeuverAdditionalEventHidden();
}

/// Every turn the maneuver banner can be asked to draw.
enum ManeuverInstruction {
  /// No turn to show.
  none,

  /// Start of the route.
  start,

  /// Arrival at the destination.
  finish,

  /// Carry straight on through the junction.
  crossroadStraight,

  /// Bear slightly left at the junction.
  crossroadSlightlyLeft,

  /// Turn left at the junction.
  crossroadLeft,

  /// Turn sharply left at the junction.
  crossroadSharplyLeft,

  /// Bear slightly right at the junction.
  crossroadSlightlyRight,

  /// Turn right at the junction.
  crossroadRight,

  /// Turn sharply right at the junction.
  crossroadSharplyRight,

  /// Keep to the left lane through the junction.
  crossroadKeepLeft,

  /// Keep to the right lane through the junction.
  crossroadKeepRight,

  /// Turn back at the junction.
  crossroadUturn,

  /// Leave the roundabout straight ahead.
  roundaboutForward,

  /// Leave the roundabout 45 degrees to the left.
  roundaboutLeft45,

  /// Leave the roundabout 90 degrees to the left.
  roundaboutLeft90,

  /// Leave the roundabout 135 degrees to the left.
  roundaboutLeft135,

  /// Leave the roundabout 45 degrees to the right.
  roundaboutRight45,

  /// Leave the roundabout 90 degrees to the right.
  roundaboutRight90,

  /// Leave the roundabout 135 degrees to the right.
  roundaboutRight135,

  /// Go all the way round the roundabout and come back.
  roundaboutBackward,

  /// Take the next exit off the roundabout.
  roundaboutExit,

  /// Turn back the way you came.
  uturn,

  /// Cross the road on foot.
  roadCrossing;

  /// Maps the instruction name the native side sends onto a value,
  /// falling back to [none] for anything unrecognised.
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
