import 'dart:async';

import 'package:flutter/services.dart';

/// Global handler for CarPlay → Flutter sound change notifications.
///
/// On a real CarPlay device, the view-specific EventChannel's eventSink
/// is often nil because the phone scene is backgrounded. This plugin-level
/// MethodChannel is tied to the FlutterEngine and is always available.
///
/// Usage:
/// ```dart
/// CarPlaySoundChannel.instance.soundChangedEvents.listen((isSoundOn) { ... });
/// ```
class CarPlaySoundChannel {
  CarPlaySoundChannel._() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  /// The one handler for the whole app; it is tied to the FlutterEngine
  /// rather than to any view.
  static final CarPlaySoundChannel instance = CarPlaySoundChannel._();

  static const _channel = MethodChannel('com.dgis.carplay_events');

  final _controller = StreamController<bool>.broadcast();

  /// Stream of sound-on/off changes originating from CarPlay.
  /// Emits `true` when sound is enabled, `false` when disabled.
  Stream<bool> get soundChangedEvents => _controller.stream;

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    if (call.method == 'soundChanged') {
      final isSoundEnabled = call.arguments as bool;
      _controller.add(isSoundEnabled);
    }
  }

  /// Dispose the channel handler (typically never called — singleton lives
  /// for the lifetime of the app).
  Future<void> dispose() async {
    await _controller.close();
    _channel.setMethodCallHandler(null);
  }
}
