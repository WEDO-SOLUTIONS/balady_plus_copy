import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mapness/shared/constants/advanced_metrics_constants.dart';

/// Load time metrics
/// We calculate the load time of the app in ms
class LoadTimeMetrics {
  /// Load time in ms
  final int loadTime;

  /// Load type: cold, warm, hot
  final LoadType loadType;

  /// Device type
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

  /// Session ID
  /// Example: 123e4567-e89b-12d3-a456-426614174000
  final String sessionId;

  /// Location: latitude and longitude
  /// Example: [37.7749, 122.4194]
  final List<double> location;

  const LoadTimeMetrics({
    required this.loadTime,
    required this.deviceType,
    required this.appVersion,
    required this.timestamp,
    required this.networkType,
    required this.sessionId,
    required this.location,
    this.loadType = LoadType.unknown,
  });

  /// Convert the object to a Map
  Map<String, dynamic> toJson() => {
        AdvancedMetricsConstants.keys.loadTime: loadTime,
        AdvancedMetricsConstants.keys.loadType: loadType.name,
        AdvancedMetricsConstants.keys.deviceType: deviceType,
        AdvancedMetricsConstants.keys.appVersion: appVersion,
        AdvancedMetricsConstants.keys.timestamp: timestamp,
        AdvancedMetricsConstants.keys.networkType: networkType.name,
        AdvancedMetricsConstants.keys.sessionId: sessionId,
        AdvancedMetricsConstants.keys.location: location,
      };

  @override
  String toString() =>
      'LoadTime:  1. Load Time: $loadTime ms, 2. Load Type: $loadType, 3. Device type: $deviceType, 4. App Version: $appVersion, 5. Timestamp: $timestamp, 6. Network type: $networkType, 7. Session Id: $sessionId, 8. Location: $location';
}

enum LoadType {
  cold,
  warm,
  hot,
  unknown,
}
