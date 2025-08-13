import 'dart:convert';

import 'package:battery_plus/battery_plus.dart';
import 'package:collection/collection.dart';
import 'package:mapness/shared/constants/advanced_metrics_constants.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Battery usage metrics
class BatteryUsage {
  /// Battery usage metrics in percentage per hour
  /// Example: 0.1 %/h
  final double batteryUsage;

  /// Time that the app is running
  /// Example: 36000 ms
  final double sessionDuration;

  /// Location latitude and longitude
  /// Example: [37.7749, 122.4194] or null
  /// If the location is null, the location is not available or the error occurred
  final List<double>? location;

  /// Active processes
  /// Example: [com.google.maps, com.mapbox.navigation]
  final List<String> activeProcesses;

  /// Device state
  /// Example: charging, discharging
  final BatteryState deviceState;

  /// Is the device is safe mode
  /// Example: true, false
  final bool isInBatterySaveMode;

  const BatteryUsage({
    required this.batteryUsage,
    required this.sessionDuration,
    required this.activeProcesses,
    required this.deviceState,
    required this.isInBatterySaveMode,
    this.location,
  });

  /// Convert the object to a Map
  Map<String, dynamic> toJson() => {
        AdvancedMetricsConstants.keys.batteryUsage: batteryUsage,
        AdvancedMetricsConstants.keys.sessionDuration: sessionDuration,
        AdvancedMetricsConstants.keys.location: location,
        AdvancedMetricsConstants.keys.activeProcesses: activeProcesses,
        AdvancedMetricsConstants.keys.deviceState: deviceState.name,
        AdvancedMetricsConstants.keys.isInBatterySaveMode: isInBatterySaveMode,
      };

  /// Convert the object to a JSON string
  String toJsonString() => jsonEncode(toJson());

  /// Create a BatteryUsage object from a JSON object
  static BatteryUsage? fromJson(String jsonString) {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;

      final batteryUsage = json[AdvancedMetricsConstants.keys.batteryUsage] as double;
      final deviceState =
          BatteryState.values.firstWhereOrNull((e) => json[AdvancedMetricsConstants.keys.deviceState] == e.name) ??
              BatteryState.unknown;
      final isInBatterySaveMode = json[AdvancedMetricsConstants.keys.isInBatterySaveMode] as bool;
      final sessionDuration = json[AdvancedMetricsConstants.keys.sessionDuration] as double;

      final location = json.containsKey(AdvancedMetricsConstants.keys.location)
          ? (json[AdvancedMetricsConstants.keys.location] as List<dynamic>).map((e) => e as double).toList()
          : null;
      final activeProcesses = json.containsKey(AdvancedMetricsConstants.keys.activeProcesses)
          ? (json[AdvancedMetricsConstants.keys.activeProcesses] as List<dynamic>).map((e) => e as String).toList()
          : <String>[];

      return BatteryUsage(
        batteryUsage: batteryUsage,
        sessionDuration: sessionDuration,
        location: location,
        activeProcesses: activeProcesses,
        deviceState: deviceState,
        isInBatterySaveMode: isInBatterySaveMode,
      );
    } catch (e) {
      logger.log('BatteryUsage fromJson ${e.toString()}');
      return null;
    }
  }

  @override
  String toString() =>
      '${AdvancedMetricsConstants.debugConsole}::${AdvancedMetricsConstants.batteryUsage}. 1. Battery Usage: $batteryUsage %/min, 2. The app worked for: $sessionDuration ms, 3. Location: $location, 4. Active Processes: $activeProcesses, 5. Device State: $deviceState, 6. Is in Battery Save Mode: $isInBatterySaveMode';
}
