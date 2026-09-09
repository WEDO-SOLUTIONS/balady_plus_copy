/// Durable, app-wide activation status for Friends on Map (BRD S-01/S-02).
///
/// [foregroundDenied] and [revoked] are live reads off the OS permission
/// state, not persisted flags — only "has the user ever completed
/// activation" is persisted (see `friends_on_map_activated.dart`). A resumed
/// app re-derives whichever of these applies from a fresh
/// `Geolocator.checkPermission()` call.
enum FriendsOnMapActivationStatus {
  /// R-01: never activated, or activated then deactivated. Nothing is
  /// collected or transmitted in this state.
  notActivated,

  /// R-05: the user attempted activation and the OS foreground permission
  /// request was denied (or the location service itself is off).
  foregroundDenied,

  /// R-06: activated with foreground permission only — position won't
  /// update for friends while the app is closed.
  activeForegroundOnly,

  /// Activated with background ("always") permission too.
  activeWithBackground,

  /// R-07: was active, but the OS permission has since been revoked.
  revoked,
}
