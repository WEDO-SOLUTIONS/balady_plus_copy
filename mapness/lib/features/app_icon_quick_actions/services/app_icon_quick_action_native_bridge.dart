import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Reads shortcut keys captured in native launch/warm intents (pre-warmed engine safe).
class AppIconQuickActionNativeBridge {
  AppIconQuickActionNativeBridge._();

  static const MethodChannel _channel = MethodChannel('momra.balady/app_icon_quick_action');

  static Future<String?> peekPendingShortcut() async {
    if (!_isSupported) {
      return null;
    }
    try {
      return await _channel.invokeMethod<String>('peekPendingShortcut');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AppIconQuickActions: native peek failed: $e');
      }
      return null;
    }
  }

  static Future<String?> consumePendingShortcut() async {
    if (!_isSupported) {
      return null;
    }
    try {
      final key = await _channel.invokeMethod<String>('consumePendingShortcut');
      if (key != null && key.isNotEmpty && kDebugMode) {
        debugPrint('AppIconQuickActions: native consume: $key');
      }
      return key;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AppIconQuickActions: native consume failed: $e');
      }
      return null;
    }
  }

  static bool get _isSupported => Platform.isAndroid || Platform.isIOS;
}
