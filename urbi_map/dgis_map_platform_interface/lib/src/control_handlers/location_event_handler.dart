import 'dart:async';

import 'package:dgis_map_platform_interface/library.dart';

/// Drives the my-location control and reports back when the location layer
/// is switched on or off, or when the camera changes how it follows.
class LocationEventHandler {
  /// Creates the handler on top of the platform [MapApi].
  LocationEventHandler(this._api);

  /// Every change in whether the location layer is showing.
  Stream<LocationEnabledEvent> get locationEnabledEvents => _locationEnabledController.stream;

  /// Every change in how the camera follows the user's location.
  Stream<LocationFollowEvent> get locationFollowEvents => _locationFollowController.stream;

  final MapApi _api;
  final _locationEnabledController = StreamController<LocationEnabledEvent>.broadcast();
  final _locationFollowController = StreamController<LocationFollowEvent>.broadcast();

  /// Decodes the location layer's state off the platform channel and
  /// publishes it on [locationEnabledEvents].
  void enabledEvent(Map<dynamic, dynamic> map) {
    _locationEnabledController.sink.add(LocationEnabledEvent(isEnabled: map['value'] as bool));
  }

  /// Decodes the follow mode off the platform channel and publishes it on
  /// [locationFollowEvents].
  void followEvent(Map<dynamic, dynamic> map) {
    _locationFollowController.sink.add(LocationFollowEvent(LocationFollowType.fromValue(map['value'])));
  }

  /// Asks the native map to step to the next follow mode, which is what the
  /// my-location button does when tapped.
  Future<void> toggleFollowState() => _api.toggleFollowState();

  /// Closes both location streams.
  Future<void> dispose() async {
    await _locationFollowController.close();
    await _locationEnabledController.close();
  }
}
