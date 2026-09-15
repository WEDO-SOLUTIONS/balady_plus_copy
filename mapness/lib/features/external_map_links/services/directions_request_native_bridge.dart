import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Talks to `ios/Runner/DirectionsRequestChannel.swift`.
///
/// Apple Maps / Find My hand a `MKDirectionsRequest` to the app through the
/// SceneDelegate, which may run before Dart is listening on a pre-warmed
/// engine. The native side therefore both pushes the request and keeps it in a
/// pending slot we can poll; there is no Android counterpart for this channel.
class DirectionsRequestNativeBridge {
  DirectionsRequestNativeBridge._();

  static const MethodChannel _channel = MethodChannel('momra.balady/directions_request');

  /// Listens for requests pushed while the engine is already running.
  static void setMethodCallHandler(Future<void> Function(Map<String, dynamic> payload) onRequest) {
    _channel.setMethodCallHandler((call) async {
      if (call.method != 'onDirectionsRequest') {
        return null;
      }
      final arguments = call.arguments;
      if (arguments is! Map) {
        return null;
      }
      await onRequest(Map<String, dynamic>.from(arguments));
      return null;
    });
  }

  /// Reads the stored request without clearing it (cold start / resume poll).
  static Future<Map<String, dynamic>?> peekPending() => _invoke('peekPendingDirectionsRequest');

  /// Reads and clears the stored request so it cannot re-fire on a later resume.
  static Future<Map<String, dynamic>?> consumePending() => _invoke('consumePendingDirectionsRequest');

  static Future<Map<String, dynamic>?> _invoke(String method) async {
    if (!_isSupported) {
      return null;
    }
    try {
      final payload = await _channel.invokeMapMethod<String, dynamic>(method);
      return payload == null ? null : Map<String, dynamic>.from(payload);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ExternalDirections: native $method failed: $e');
      }
      return null;
    }
  }

  static bool get _isSupported => Platform.isIOS;
}
