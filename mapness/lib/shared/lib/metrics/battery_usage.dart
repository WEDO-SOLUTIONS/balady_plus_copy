import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mapness/shared/constants/advanced_metrics_constants.dart';

/// Battery usage metrics
class BatteryUsage {
  /// Battery usage metrics in percentage per hour
  /// Example: 0.1 %/h
  final double batteryUsage;

  /// App runtime in ms
  /// Example: 36000 ms
  final double appRuntime;

  /// Devicer type
  /// Example: iPhone 12 Pro or Samsung Galaxy S21
  final String deviceType;

  /// App version
  /// Example: 1.0.0
  final String appVersion;

  /// Timestamp
  /// Example: 2021-10-01T12:00:00Z
  final String timestamp;

  /// Network type
  /// Example: WiFi, 4G, 3G, 2G
  final ConnectivityResult networkType;

  /// Location latitude and longitude
  /// Example: [37.7749, 122.4194]
  final List<double> location;

  /// Active processes
  /// Example: [com.google.maps, com.mapbox.navigation]
  final List<String> activeProcesses;

  /// Device state
  /// Example: charging, discharging
  final BatteryState deviceState;

  const BatteryUsage({
    required this.batteryUsage,
    required this.appRuntime,
    required this.deviceType,
    required this.appVersion,
    required this.timestamp,
    required this.networkType,
    required this.location,
    required this.activeProcesses,
    required this.deviceState,
  });

  /// Convert the object to a Map
  Map<String, dynamic> toJson() => {
        AdvancedMetricsConstants.keys.batteryUsage: batteryUsage,
        AdvancedMetricsConstants.keys.appRuntime: appRuntime,
        AdvancedMetricsConstants.keys.deviceType: deviceType,
        AdvancedMetricsConstants.keys.appVersion: appVersion,
        AdvancedMetricsConstants.keys.timestamp: timestamp,
        AdvancedMetricsConstants.keys.networkType: networkType.name,
        AdvancedMetricsConstants.keys.location: location,
        AdvancedMetricsConstants.keys.activeProcesses: activeProcesses,
        AdvancedMetricsConstants.keys.deviceState: deviceState.name,
      };

  @override
  String toString() =>
      'BatteryUsage: 1. Battery Usage: $batteryUsage %/h, 2. App Runtime: $appRuntime ms, 3. Device type: $deviceType, 4. App Version: $appVersion, 5. Timestamp: $timestamp, 6. Network type: $networkType, 7. Location: $location, 8. Active Processes: $activeProcesses, 9. Device State: $deviceState';
}
