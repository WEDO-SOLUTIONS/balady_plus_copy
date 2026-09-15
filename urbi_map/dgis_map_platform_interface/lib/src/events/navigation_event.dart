/// Phase the native navigation session is in.
enum NavigationEvent {
  /// Guiding along a route.
  navigation,

  /// Looking for a route, before guidance starts.
  routeSearch,

  /// The destination was reached and the session ended.
  finished,

  /// No session is running.
  disabled;

  /// Name of the platform channel event these are decoded from.
  static const name = "navigationEvent";
}
