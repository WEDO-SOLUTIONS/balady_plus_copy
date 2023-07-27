import '../library.dart';

/// @nodoc
extension IconPath on ManeuverInstruction {
  /// Icon for instruction
  String? get iconPath {
    const prefix = "packages/dgis_map/assets/svg";
    switch (this) {
      case ManeuverInstruction.none:
      case ManeuverInstruction.road_crossing:
        return null;
      case ManeuverInstruction.start:
        return "$prefix/dgis_ic_maneuver_start_light.svg";
      case ManeuverInstruction.finish:
        return "$prefix/dgis_ic_maneuver_finish.svg";
      case ManeuverInstruction.crossroad_straight:
        return "$prefix/dgis_ic_maneuver_crossroad_straight.svg";
      case ManeuverInstruction.crossroad_slightly_left:
        return "$prefix/dgis_ic_maneuver_crossroad_slightly_left.svg";
      case ManeuverInstruction.crossroad_left:
        return "$prefix/dgis_ic_maneuver_crossroad_left_light.svg";
      case ManeuverInstruction.crossroad_sharply_left:
        return "$prefix/dgis_ic_maneuver_crossroad_sharply_left.svg";
      case ManeuverInstruction.crossroad_slightly_right:
        return "$prefix/dgis_ic_maneuver_crossroad_slightly_right.svg";
      case ManeuverInstruction.crossroad_right:
        return "$prefix/dgis_ic_maneuver_crossroad_right_light.svg";
      case ManeuverInstruction.crossroad_sharply_right:
        return "$prefix/dgis_ic_maneuver_crossroad_sharply_right.svg";
      case ManeuverInstruction.crossroad_keep_left:
        return "$prefix/dgis_ic_maneuver_crossroad_keep_left.svg";
      case ManeuverInstruction.crossroad_keep_right:
        return "$prefix/dgis_ic_maneuver_crossroad_keep_right.svg";
      case ManeuverInstruction.crossroad_uturn:
        return "$prefix/dgis_ic_maneuver_crossroad_uturn.svg";
      case ManeuverInstruction.roundabout_forward:
        return "$prefix/dgis_ic_maneuver_roundabout_forward.svg";
      case ManeuverInstruction.roundabout_left_45:
        return "$prefix/dgis_ic_maneuver_roundabout_left_45.svg";
      case ManeuverInstruction.roundabout_left_90:
        return "$prefix/dgis_ic_maneuver_roundabout_left_90.svg";
      case ManeuverInstruction.roundabout_left_135:
        return "$prefix/dgis_ic_maneuver_roundabout_left_135.svg";
      case ManeuverInstruction.roundabout_right_45:
        return "$prefix/dgis_ic_maneuver_roundabout_right_45.svg";
      case ManeuverInstruction.roundabout_right_90:
        return "$prefix/dgis_ic_maneuver_roundabout_right_90.svg";
      case ManeuverInstruction.roundabout_right_135:
        return "$prefix/dgis_ic_maneuver_roundabout_right_135.svg";
      case ManeuverInstruction.roundabout_backward:
        return "$prefix/dgis_ic_maneuver_roundabout_backward.svg";
      case ManeuverInstruction.roundabout_exit:
        return "$prefix/dgis_ic_maneuver_roundabout_exit.svg";
      case ManeuverInstruction.uturn:
        return "$prefix/dgis_ic_maneuver_uturn_light.svg";
    }
  }
}
