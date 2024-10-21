import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mapness/shared/constants/advanced_metrics_constants.dart';

class RouteCalculationMetrics {
  /// A value in milliseconds indicating how long it took to calculate the route.
  /// Example: 1000
  final int duration;

  /// Coordinates (latitude and longitude) of the starting and ending points of the route.
  /// Example: [[37.7749, 122.4194], [37.7749, 122.4194]]
  final List<List<double>> route;

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

  const RouteCalculationMetrics({
    required this.duration,
    required this.route,
    required this.deviceType,
    required this.appVersion,
    required this.timestamp,
    required this.networkType,
    required this.sessionId,
  });

  /// Convert the object to a Map
  Map<String, dynamic> toJson() => {
        AdvancedMetricsConstants.keys.routeCalculationTime: duration,
        AdvancedMetricsConstants.keys.startAndEndPoints: route,
        AdvancedMetricsConstants.keys.deviceType: deviceType,
        AdvancedMetricsConstants.keys.appVersion: appVersion,
        AdvancedMetricsConstants.keys.timestamp: timestamp,
        AdvancedMetricsConstants.keys.networkType: networkType.name,
        AdvancedMetricsConstants.keys.sessionId: sessionId,
      };

  @override
  String toString() =>
      'RouteCalculationMetrics(duration: $duration, route: $route, deviceType: $deviceType, appVersion: $appVersion, timestamp: $timestamp, networkType: $networkType, sessionId: $sessionId)';
}
