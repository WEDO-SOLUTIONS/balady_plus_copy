import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';

/// Controller for zoomin in/out
class NaviZoomController {
  /// @nodoc
  NaviZoomController(
    this._events,
    this._onZoomAction,
  );

  void init() {
    _subscriptions = [
      zoomInEvents.listen((event) {
        zoomInState.value = event.isEnabled;
      }),
      zoomOutEvents.listen((event) {
        zoomOutState.value = event.isEnabled;
      }),
    ];
  }

  void dispose() {
    for (var s in _subscriptions) {
      s.cancel();
    }
    _subscriptions.clear();
    zoomInState.dispose();
    zoomOutState.dispose();
  }

  /// All events without filtering
  final Stream<ZoomControlEnabledEvent> _events;
  final Future<void> Function(ZoomControlType, {required bool isPressed}) _onZoomAction;
  late List<StreamSubscription> _subscriptions;

  final zoomInState = ValueNotifier(true);
  final zoomOutState = ValueNotifier(true);

  Future<void> onTapUp(ZoomControlType type) async {
    return _onZoomAction(type, isPressed: false);
  }

  Future<void> onTapDown(ZoomControlType type) async {
    return _onZoomAction(type, isPressed: true);
  }

  Stream<ZoomControlEnabledEvent> get zoomInEvents => _events.where((event) => event.button == ZoomControlType.zoomIn);

  Stream<ZoomControlEnabledEvent> get zoomOutEvents =>
      _events.where((event) => event.button == ZoomControlType.zoomOut);
}
