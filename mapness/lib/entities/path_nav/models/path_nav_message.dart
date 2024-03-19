import 'package:mapness/widgets/path_nav/ui/path_nav_message_widget.dart';

class PathNavMessage {

  const PathNavMessage({
    required this.state,
    required this.comment,
  });
  final PathNavManeuverState state;
  final String comment;
}
