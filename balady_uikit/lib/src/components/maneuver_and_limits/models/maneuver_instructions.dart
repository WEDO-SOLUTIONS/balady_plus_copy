enum BaladyManeuverInstruction {
  none,
  start,
  finish,
  crossroadLeft,
  crossroadStraight,
  crossroadSlightlyLeft,
  crossroadSharplyLeft,
  crossroadSlightlyRight,
  crossroadRight,
  crossroadSharplyRight,
  crossroadKeepLeft,
  crossroadKeepRight,
  // SDK name: roundaboutForward
  ringroadForward,

  /// SDK name: roundaboutLeft135,
  ringroadLeft45,

  /// SDK name: roundaboutLeft90
  ringroadLeft90,
  // SDK name: roundaboutLeft135
  ringroadLeft135,
  // SDK name: roundaboutRight45
  ringroadRight45,

  /// SDK name: roundaboutRight90
  ringroadRight90,
  //SDK name: roundaboutRight135,
  ringroadRight135,
  // SDK name:roundaboutBackward,
  ringroadBackward,

  /// SDK name: roundaboutExit
  ringRoadExit,

  /// SDK name: uturn, crossroadUturn
  turnOverRightHand,
}

extension IconPath on BaladyManeuverInstruction {
  /// Icon for instruction
  String? get iconPath {
    const prefix = 'assets/icons/maneuver';
    switch (this) {
      case BaladyManeuverInstruction.none:
        return null;
      case BaladyManeuverInstruction.finish:
        return '$prefix/Road_finish.svg';
      case BaladyManeuverInstruction.start:
      case BaladyManeuverInstruction.crossroadStraight:
        return '$prefix/Crossroad_straight.svg';
      case BaladyManeuverInstruction.crossroadSlightlyLeft:
        return '$prefix/Crossroad_slightly_left.svg';
      case BaladyManeuverInstruction.crossroadLeft:
        return '$prefix/Crossroad_left.svg';
      case BaladyManeuverInstruction.crossroadSharplyLeft:
        return '$prefix/Crossroad_sharply_left.svg';
      case BaladyManeuverInstruction.crossroadSlightlyRight:
        return '$prefix/Crossroad_slightly_right.svg';
      case BaladyManeuverInstruction.crossroadRight:
        return '$prefix/Crossroad_right.svg';
      case BaladyManeuverInstruction.crossroadSharplyRight:
        return '$prefix/Crossroad_sharply_right.svg';
      case BaladyManeuverInstruction.crossroadKeepLeft:
        return '$prefix/Crossroad_keep_left.svg';
      case BaladyManeuverInstruction.crossroadKeepRight:
        return '$prefix/Crossroad_keep_right.svg';
      case BaladyManeuverInstruction.ringroadForward:
        return '$prefix/Ringroad_forward.svg';
      case BaladyManeuverInstruction.ringroadLeft45:
        return '$prefix/Ringroad_left_45.svg';
      case BaladyManeuverInstruction.ringroadLeft90:
        return '$prefix/Ringroad_left_90.svg';
      case BaladyManeuverInstruction.ringroadLeft135:
        return '$prefix/Ringroad_left_135.svg';
      case BaladyManeuverInstruction.ringroadRight45:
        return '$prefix/Ringroad_right_45.svg';
      case BaladyManeuverInstruction.ringroadRight90:
        return '$prefix/Ringroad_right_90.svg';
      case BaladyManeuverInstruction.ringroadRight135:
        return '$prefix/Ringroad_right_135.svg';
      case BaladyManeuverInstruction.ringroadBackward:
        return '$prefix/Ringroad_backward.svg';
      case BaladyManeuverInstruction.ringRoadExit:
        return '$prefix/Ringroad_exit.svg';
      case BaladyManeuverInstruction.turnOverRightHand:
        return '$prefix/Turn_over_right_hand.svg';
    }
  }
}
