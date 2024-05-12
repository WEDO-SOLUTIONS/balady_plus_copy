import 'package:dgis_map/library.dart';

class PathNavMessage {
  final NaviMessageEventState state;
  final String comment;

  const PathNavMessage({
    required this.state,
    required this.comment,
  });
}
