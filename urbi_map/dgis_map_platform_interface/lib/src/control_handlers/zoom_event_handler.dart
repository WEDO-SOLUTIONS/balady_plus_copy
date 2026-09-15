import 'dart:async';

import '../events/zoom_control_events.dart';
import '../pigeons/messages.g.dart';

/// Drives the on-map zoom buttons and reports back when either of them
/// becomes available or unavailable.
class ZoomEventHandler {
  /// Creates the handler on top of the platform [MapApi].
  ZoomEventHandler(this._api);

  /// Every change in whether a zoom button can still be pressed.
  Stream<ZoomControlEnabledEvent> get zoomControlEnabledEvents => _zoomController.stream;

  final MapApi _api;
  final _zoomController = StreamController<ZoomControlEnabledEvent>.broadcast();

  /// Tells the native map that [btn] was pressed or released. The map keeps
  /// zooming for as long as the button is held.
  Future<void> onZoomAction(ZoomControlType btn, {required bool isPressed}) async {
    switch (btn) {
      case ZoomControlType.zoomIn:
        return isPressed ? _api.zoomDown(ZoomControlMessage.zoomIn) : _api.zoomUp(ZoomControlMessage.zoomIn);
      case ZoomControlType.zoomOut:
        return isPressed ? _api.zoomDown(ZoomControlMessage.zoomOut) : _api.zoomUp(ZoomControlMessage.zoomOut);
    }
  }

  /// Decodes the zoom-in button's state off the platform channel and
  /// publishes it on [zoomControlEnabledEvents].
  void zoomInEvent(Map<dynamic, dynamic> map) {
    _zoomController.sink.add(ZoomControlEnabledEvent(button: ZoomControlType.zoomIn, isEnabled: map['value'] as bool));
  }

  /// Decodes the zoom-out button's state off the platform channel and
  /// publishes it on [zoomControlEnabledEvents].
  void zoomOutEvent(Map<dynamic, dynamic> map) {
    _zoomController.sink.add(ZoomControlEnabledEvent(button: ZoomControlType.zoomOut, isEnabled: map['value'] as bool));
  }

  /// Closes the zoom control stream.
  Future<void> dispose() async {
    await _zoomController.close();
  }
}
