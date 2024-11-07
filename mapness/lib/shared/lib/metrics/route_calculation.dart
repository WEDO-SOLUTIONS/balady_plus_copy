import 'package:mapness/shared/constants/advanced_metrics_constants.dart';

class RouteCalculationMetrics {
  /// A value in milliseconds indicating how long it took to calculate the route.
  /// Example: 1000
  final int duration;

  /// Coordinates (latitude and longitude) of the starting and ending points of the route.
  /// Example: [[37.7749, 122.4194], [37.7749, 122.4194]]
  final List<List<double>> route;

  const RouteCalculationMetrics({
    required this.duration,
    required this.route,
  });

  /// Convert the object to a Map
  Map<String, dynamic> toJson() => {
        AdvancedMetricsConstants.keys.routeCalculationTime: duration,
        AdvancedMetricsConstants.keys.startAndEndPoints: route,
      };

  @override
  String toString() =>
      '${AdvancedMetricsConstants.debugConsole}::${AdvancedMetricsConstants.routeCalculationTime}: duration: $duration ms, route: $route';
}
