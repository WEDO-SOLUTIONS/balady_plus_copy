import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';

/// Controller for zoomin in/out
class NaviZoomController {
  /// @nodoc
  NaviZoomController(this._events, this._onZoomAction);

  /// Starts mirroring the zoom events into [zoomInState] and [zoomOutState],
  /// so a widget can bind to the notifiers instead of the streams.
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

  /// Cancels the subscriptions [init] opened and releases the notifiers.
  ///
  /// Returns a future so the cancellations can be awaited - every other
  /// handler in this package disposes the same way.
  Future<void> dispose() async {
    await Future.wait(_subscriptions.map((s) => s.cancel()));
    _subscriptions.clear();
    zoomInState.dispose();
    zoomOutState.dispose();
  }

  /// All events without filtering
  final Stream<ZoomControlEnabledEvent> _events;
  final Future<void> Function(ZoomControlType, {required bool isPressed}) _onZoomAction;
  late List<StreamSubscription> _subscriptions;

  /// Whether the zoom-in button can still be pressed; false once the map is
  /// at maximum zoom.
  final zoomInState = ValueNotifier(true);

  /// Whether the zoom-out button can still be pressed; false once the map is
  /// at minimum zoom.
  final zoomOutState = ValueNotifier(true);

  /// Tells the map the button was released, which stops the zoom.
  Future<void> onTapUp(ZoomControlType type) async {
    return _onZoomAction(type, isPressed: false);
  }

  /// Tells the map the button was pressed; the map keeps zooming until
  /// [onTapUp].
  Future<void> onTapDown(ZoomControlType type) async {
    return _onZoomAction(type, isPressed: true);
  }

  /// Availability changes for the zoom-in button only.
  Stream<ZoomControlEnabledEvent> get zoomInEvents => _events.where((event) => event.button == ZoomControlType.zoomIn);

  /// Availability changes for the zoom-out button only.
  Stream<ZoomControlEnabledEvent> get zoomOutEvents =>
      _events.where((event) => event.button == ZoomControlType.zoomOut);
}
