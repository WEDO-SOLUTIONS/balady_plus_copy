import 'package:flutter/services.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Bridge to the native "Navigation Live Updates" surfaces (iOS Live Activities,
/// Android Live Updates / ongoing notification).
///
/// The native side is fully data-driven by the navigation engine; Dart only
/// supplies session metadata (destination, route type, language) and receives
/// the "End Trip tapped on the widget" signal back. All outbound calls are
/// best-effort: the native implementation may be absent on some
/// platforms/builds, so failures are logged and swallowed.
class NavigationLiveUpdates {
  NavigationLiveUpdates._() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  static final NavigationLiveUpdates instance = NavigationLiveUpdates._();

  static const MethodChannel _channel = MethodChannel('balady/navigation_live_updates');

  /// Invoked when the user tapped "End Trip" on the lock-screen widget.
  /// By the time this fires the native side has already stopped the navigation
  /// engine and removed the widget — the callback only reconciles the Dart UI.
  void Function()? onEndTripRequested;

  /// Sends the current navigation session metadata to the native side.
  ///
  /// [strings] carries the app's localized copy for the widget: the iOS
  /// extension has no access to the Flutter localizations and the Android
  /// notification would otherwise use the plugin's own resources. Keys that are
  /// missing fall back to the native defaults.
  Future<void> setSessionMetadata({
    required String? destinationName,
    required String routeType,
    required String language,
    Map<String, String> strings = const <String, String>{},
    bool enabled = true,
  }) async {
    try {
      await _channel.invokeMethod<void>('setSessionMetadata', <String, dynamic>{
        'destinationName': destinationName,
        'routeType': routeType,
        'language': language,
        'strings': strings,
        'enabled': enabled,
      });
    } catch (e) {
      logger.log('NavigationLiveUpdates: setSessionMetadata failed: $e', logLevel: MapnessLogLevel.info);
    }
  }

  /// Ends the live updates session (removes the widget/notification).
  Future<void> endSession() async {
    try {
      await _channel.invokeMethod<void>('endSession');
    } catch (e) {
      logger.log('NavigationLiveUpdates: endSession failed: $e', logLevel: MapnessLogLevel.info);
    }
  }

  Future<Object?> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onEndTripRequested':
        onEndTripRequested?.call();
      default:
        // Unknown inbound method — ignore to stay forward-compatible.
        break;
    }
    return null;
  }
}
