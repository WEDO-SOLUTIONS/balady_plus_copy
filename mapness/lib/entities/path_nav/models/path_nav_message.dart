import 'package:mapness/entities/path_nav/models/path_nav_message_state.dart';

/// Warning message from the navigation system
class PathNavMessage {
  /// The state of the message.
  final PathNavMessageState state;

  /// Creates a new PathNavMessage.
  const PathNavMessage({
    required this.state,
  });
}
