/// How the map camera follows the user's location.
enum LocationFollowType {
  /// The camera ignores the location and stays where the user left it.
  off,

  /// The camera keeps the location centred but does not rotate with it.
  followPosition,

  /// The camera keeps the location centred and turns to face the heading.
  followDirection;

  /// Maps the raw integer the native side sends onto a follow type,
  /// falling back to [off] for anything unrecognised.
  static LocationFollowType fromValue(int value) {
    switch (value) {
      case 0:
        return LocationFollowType.off;
      case 1:
        return LocationFollowType.followPosition;
      case 2:
        return LocationFollowType.followDirection;
      default:
        return LocationFollowType.off;
    }
  }
}

/// Reports that the location layer was switched on or off.
class LocationEnabledEvent {
  /// Creates the event with the layer's new [isEnabled] state.
  LocationEnabledEvent({required this.isEnabled});

  /// Name of the platform channel event this is decoded from.
  static const name = 'locationEnabledEvent';

  /// Whether the location layer is now showing.
  final bool isEnabled;
}

/// Reports that the camera changed how it follows the user's location.
class LocationFollowEvent {
  /// Creates the event for the new [followType].
  LocationFollowEvent(this.followType);

  /// Name of the platform channel event this is decoded from.
  static const name = 'locationFollowEvent';

  /// How the camera follows the location from now on.
  final LocationFollowType followType;
}
