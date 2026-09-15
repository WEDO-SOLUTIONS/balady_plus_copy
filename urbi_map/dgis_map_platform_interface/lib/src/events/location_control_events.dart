enum LocationFollowType {
  off,
  followPosition,
  followDirection;

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

class LocationEnabledEvent {
  LocationEnabledEvent({required this.isEnabled});

  static const name = 'locationEnabledEvent';

  final bool isEnabled;
}

class LocationFollowEvent {
  LocationFollowEvent(this.followType);

  static const name = 'locationFollowEvent';

  final LocationFollowType followType;
}
