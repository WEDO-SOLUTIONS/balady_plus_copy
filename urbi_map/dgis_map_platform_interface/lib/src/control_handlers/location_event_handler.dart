import 'dart:async';

import 'package:dgis_map_platform_interface/library.dart';

class LocationEventHandler {
  LocationEventHandler(this._api);

  Stream<LocationEnabledEvent> get locationEnabledEvents => _locationEnabledController.stream;

  Stream<LocationFollowEvent> get locationFollowEvents => _locationFollowController.stream;

  final MapApi _api;
  final _locationEnabledController = StreamController<LocationEnabledEvent>.broadcast();
  final _locationFollowController = StreamController<LocationFollowEvent>.broadcast();

  void enabledEvent(Map<dynamic, dynamic> map) {
    _locationEnabledController.sink.add(LocationEnabledEvent(isEnabled: map['value'] as bool));
  }

  void followEvent(Map<dynamic, dynamic> map) {
    _locationFollowController.sink.add(LocationFollowEvent(LocationFollowType.fromValue(map['value'])));
  }

  Future<void> toggleFollowState() => _api.toggleFollowState();

  Future<void> dispose() async {
    await _locationFollowController.close();
    await _locationEnabledController.close();
  }
}
