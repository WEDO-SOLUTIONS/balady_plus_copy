import 'package:mapness/widgets/path_nav/ui/path_nav_message_widget.dart';

class PathNavMessage {
  final PathNavManeuverState state;
  final String comment;

  const PathNavMessage({
    required this.state,
    required this.comment,
  });
}
