import 'package:balady_uikit/src/components/maneuver_and_limits/models/path_nav_state.dart';

/// Message data to be displayed on the map if a maneuver is not reseved.
/// Should be used to pass the data to the [BaladyManeuverAlert] widget.
/// This includes the [state] of the connection to the internet and a [comment] to be displayed.
class ManeuverMessageModel {
  /// The state of the connection to the internet.
  final ManeuverMessageState state;

  /// The comment to be displayed.
  final String comment;

  /// Constructor
  const ManeuverMessageModel({
    required this.state,
    required this.comment,
  });
}
