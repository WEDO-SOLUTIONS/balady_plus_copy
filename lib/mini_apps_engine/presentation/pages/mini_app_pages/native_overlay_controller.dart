import 'package:flutter/services.dart';

class NativeOverlayController {
  static const MethodChannel _channel = MethodChannel('native_overlay_channel');

  static Future<void> showOverlay() async {
    try {
      await _channel.invokeMethod('showOverlay');
    } catch (e) {
      print('Error showing native overlay: $e');
    }
  }

  static Future<void> hideOverlay() async {
    try {
      await _channel.invokeMethod('hideOverlay');
    } catch (e) {
      print('Error hiding native overlay: $e');
    }
  }
}