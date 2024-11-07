import 'package:mapness/shared/constants/advanced_metrics_constants.dart';

/// Load time metrics
/// We calculate the load time of the app in ms
class LoadTimeMetrics {
  /// Load time in ms
  final int loadTime;

  /// Load type: cold, warm, hot
  final LoadType loadType;

  /// Location: latitude and longitude
  /// Example: [37.7749, 122.4194] or null
  /// If the location is null, the location is not available or the error occurred
  final List<double>? location;

  const LoadTimeMetrics({
    required this.loadTime,
    this.location,
    this.loadType = LoadType.unknown,
  });

  /// Convert the object to a Map
  Map<String, dynamic> toJson() => {
        AdvancedMetricsConstants.keys.loadTime: loadTime,
        AdvancedMetricsConstants.keys.loadType: loadType.name,
        AdvancedMetricsConstants.keys.location: location,
      };

  @override
  String toString() =>
      '${AdvancedMetricsConstants.debugConsole}::${AdvancedMetricsConstants.appLoadTime}:  1. Load Time: $loadTime ms, 2. Load Type: $loadType, 3. Location: $location';
}

enum LoadType {
  cold,
  warm,
  hot,
  unknown,
}
