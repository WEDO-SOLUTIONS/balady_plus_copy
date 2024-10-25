import 'dart:convert';

import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mapness/shared/constants/advanced_metrics_constants.dart';

/// Battery usage metrics
class BatteryUsage {
  /// Battery usage metrics in percentage per hour
  /// Example: 0.1 %/h
  final double batteryUsage;

  /// Time that the app is running
  /// Example: 36000 ms
  final double sessionDuration;

  /// Devicer type
  /// Example: iPhone 12 Pro or Samsung Galaxy S21
  final String deviceType;

  /// App version
  /// Example: 1.0.0
  final String appVersion;

  /// Timestamp
  /// Example: 2021-10-01T12:00:00Z
  final String timestamp;

  /// Session ID
  /// Example: 123e4567-e89b-12d3-a456-426614174000
  final String sessionId;

  /// Network type
  /// Example: WiFi, 4G, 3G, 2G
  final ConnectivityResult networkType;

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
    required this.deviceType,
    required this.appVersion,
    required this.timestamp,
    required this.networkType,
    required this.activeProcesses,
    required this.deviceState,
    required this.sessionId,
    required this.isInBatterySaveMode,
    this.location,
  });

  /// Convert the object to a Map
  Map<String, dynamic> toJson() => {
        AdvancedMetricsConstants.keys.batteryUsage: batteryUsage,
        AdvancedMetricsConstants.keys.sessionDuration: sessionDuration,
        AdvancedMetricsConstants.keys.deviceType: deviceType,
        AdvancedMetricsConstants.keys.appVersion: appVersion,
        AdvancedMetricsConstants.keys.timestamp: timestamp,
        AdvancedMetricsConstants.keys.networkType: networkType.name,
        AdvancedMetricsConstants.keys.location: location,
        AdvancedMetricsConstants.keys.activeProcesses: activeProcesses,
        AdvancedMetricsConstants.keys.deviceState: deviceState.name,
        AdvancedMetricsConstants.keys.sessionId: sessionId,
        AdvancedMetricsConstants.keys.isInBatterySaveMode: isInBatterySaveMode,
      };

  /// Convert the object to a JSON string
  String toJsonString() => jsonEncode(toJson());

  /// Create a BatteryUsage object from a JSON object
  factory BatteryUsage.fromJson(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return BatteryUsage(
      batteryUsage: json[AdvancedMetricsConstants.keys.batteryUsage],
      sessionDuration: json[AdvancedMetricsConstants.keys.sessionDuration],
      deviceType: json[AdvancedMetricsConstants.keys.deviceType],
      appVersion: json[AdvancedMetricsConstants.keys.appVersion],
      timestamp: json[AdvancedMetricsConstants.keys.timestamp],
      networkType: json[AdvancedMetricsConstants.keys.networkType],
      location: json[AdvancedMetricsConstants.keys.location],
      activeProcesses: json[AdvancedMetricsConstants.keys.activeProcesses],
      deviceState: json[AdvancedMetricsConstants.keys.deviceState],
      sessionId: json[AdvancedMetricsConstants.keys.sessionId],
      isInBatterySaveMode: json[AdvancedMetricsConstants.keys.isInBatterySaveMode],
    );
  }

  @override
  String toString() =>
      '${AdvancedMetricsConstants.debugConsole}::${AdvancedMetricsConstants.batteryUsage}. 1. Battery Usage: $batteryUsage %/min, 2. The app worked for: $sessionDuration ms, 3. Device type: $deviceType, 4. App Version: $appVersion, 5. Timestamp: $timestamp, 6. Network type: $networkType, 7. Location: $location, 8. Active Processes: $activeProcesses, 9. Device State: $deviceState, 10. Session ID: $sessionId, 11. Is in Battery Save Mode: $isInBatterySaveMode';
}
