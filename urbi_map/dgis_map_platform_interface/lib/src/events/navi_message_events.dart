/// Condition navigation wants to tell the user about.
enum NaviMessageEventState {
  /// The GPS fix was lost and the route can no longer be followed.
  gpsLost,

  /// The route is being rebuilt, usually after leaving it.
  routeResearch,

  /// Nothing to report; clears any message already on screen.
  none,
}

/// Reports a condition navigation wants surfaced to the user.
class NaviMessageEvent {
  /// Creates the event for the given [state].
  const NaviMessageEvent(this.state);

  /// What navigation is reporting.
  final NaviMessageEventState state;

  /// Name of the platform channel event this is decoded from.
  static const name = 'messageEvent';
}
