import 'dart:async';
import 'dart:developer';

import 'package:dgis_map_platform_interface/src/events/navi_message_events.dart';

/// Message event handler for navigation messages.
/// This class is used to handle navigation messages and send them to the UI.
class MessageEventHandler {
  /// Constructor for the message event handler.
  MessageEventHandler();

  /// Public steam getter for message events.
  /// Stream is not broadcasted.
  Stream<NaviMessageEvent> get messageEvents => _controller.stream;

  final _controller = StreamController<NaviMessageEvent>();

  /// Message handler for navigation messages.
  void handleMessageEvent(Map<dynamic, dynamic> map) {
    final event = map['state'];
    if (event == NaviMessageEventState.gpsLost.name) {
      log('>> GPS Signal lost');
      _controller.sink.add(const NaviMessageEvent(NaviMessageEventState.gpsLost));
    } else if (event == NaviMessageEventState.routeResearch.name) {
      log('>> Re-routing');
      _controller.sink.add(const NaviMessageEvent(NaviMessageEventState.routeResearch));
    } else {
      log('>> None');
      _controller.sink.add(const NaviMessageEvent(NaviMessageEventState.none));
    }
  }

  /// Dispose method for the message event handler.
  /// Closes the stream controller.
  Future<void> dispose() {
    return _controller.close();
  }
}
