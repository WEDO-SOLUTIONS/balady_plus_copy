import 'dart:async';

import 'package:dgis_map/library.dart';

/// Controller for navigation GPS Lost and Re-Routing messages
class NaviMessageController {
  /// @nodoc
  NaviMessageController(this.events);

  /// All events without filtering
  final Stream<NaviMessageEvent> events;
}
