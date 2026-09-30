import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// The time-zone database is only needed to schedule local notifications, while decoding it (`latest_all`) is
/// synchronous work on the UI isolate. It is loaded on first use instead of during app start-up.
abstract final class TimeZones {
  static Future<void>? _ready;

  /// Loads the database and sets `tz.local` to the device zone, once per app run. Never throws: if the device zone
  /// cannot be resolved, `tz.local` stays at the package default (UTC), as it did before.
  static Future<void> ensureInitialized() => _ready ??= _initialize();

  static Future<void> _initialize() async {
    try {
      tz.initializeTimeZones();
      final currentTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));
    } catch (error) {
      if (kDebugMode) {
        debugPrint('TimeZones: failed to resolve the local time zone: $error');
      }
    }
  }
}
