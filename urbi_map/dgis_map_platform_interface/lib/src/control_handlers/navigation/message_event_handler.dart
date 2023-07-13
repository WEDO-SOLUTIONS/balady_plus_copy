import 'dart:async';

import '../../events/navi_message_events.dart';

class MessageEventHandler {
  MessageEventHandler();

  Stream<NaviMessageEvent> get messageEvents => _controller.stream;

  final _controller = StreamController<NaviMessageEvent>();

  void handleMessageEvent(Map<dynamic, dynamic> map) {
    if (map['state'] == NaviMessageEventState.gpsLost.name) {
      _controller.sink
          .add(const NaviMessageEvent(NaviMessageEventState.gpsLost));
    } else if (map['state'] == NaviMessageEventState.routeResearch.name) {
      _controller.sink
          .add(const NaviMessageEvent(NaviMessageEventState.routeResearch));
    } else {
      _controller.sink.add(const NaviMessageEvent(NaviMessageEventState.none));
    }
  }

  Future<void> dispose() {
    return _controller.close();
  }
}
