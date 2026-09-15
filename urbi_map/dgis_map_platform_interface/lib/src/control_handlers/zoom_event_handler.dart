import 'dart:async';

import '../events/zoom_control_events.dart';
import '../pigeons/messages.g.dart';

class ZoomEventHandler {
  ZoomEventHandler(this._api);

  Stream<ZoomControlEnabledEvent> get zoomControlEnabledEvents => _zoomController.stream;

  final MapApi _api;
  final _zoomController = StreamController<ZoomControlEnabledEvent>.broadcast();

  Future<void> onZoomAction(ZoomControlType btn, {required bool isPressed}) async {
    switch (btn) {
      case ZoomControlType.zoomIn:
        return isPressed ? _api.zoomDown(ZoomControlMessage.zoomIn) : _api.zoomUp(ZoomControlMessage.zoomIn);
      case ZoomControlType.zoomOut:
        return isPressed ? _api.zoomDown(ZoomControlMessage.zoomOut) : _api.zoomUp(ZoomControlMessage.zoomOut);
    }
  }

  void zoomInEvent(Map<dynamic, dynamic> map) {
    _zoomController.sink.add(ZoomControlEnabledEvent(button: ZoomControlType.zoomIn, isEnabled: map['value'] as bool));
  }

  void zoomOutEvent(Map<dynamic, dynamic> map) {
    _zoomController.sink.add(ZoomControlEnabledEvent(button: ZoomControlType.zoomOut, isEnabled: map['value'] as bool));
  }

  Future<void> dispose() async {
    await _zoomController.close();
  }
}
