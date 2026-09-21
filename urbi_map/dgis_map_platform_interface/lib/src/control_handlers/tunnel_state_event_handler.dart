import 'dart:async';

import 'package:dgis_map_platform_interface/library.dart';

class TunnelStateEventHandler {
  TunnelStateEventHandler();

  Stream<TunnelStateEvent> get tunnelStateEvents => _controller.stream;

  /// Last state reported by the native side, so a listener that subscribes after the
  /// tunnel was entered still knows the app should be dark.
  bool get isInTunnel => _isInTunnel;

  final _controller = StreamController<TunnelStateEvent>.broadcast();
  bool _isInTunnel = false;

  void tunnelStateChanged(Map<dynamic, dynamic> map) {
    final inTunnel = map["inTunnel"] as bool? ?? false;
    if (inTunnel == _isInTunnel) {
      return;
    }

    _isInTunnel = inTunnel;
    _controller.sink.add(TunnelStateEvent(inTunnel: inTunnel));
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
