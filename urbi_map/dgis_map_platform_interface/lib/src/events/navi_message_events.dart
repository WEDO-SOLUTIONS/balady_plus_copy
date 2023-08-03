enum NaviMessageEventState {
  gpsLost,
  routeResearch,
  none,
}

class NaviMessageEvent {
  const NaviMessageEvent(this.state);

  final NaviMessageEventState state;

  static const name = 'messageEvent';
}
