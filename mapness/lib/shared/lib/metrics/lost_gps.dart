import 'dart:convert';

import 'package:mapness/shared/constants/advanced_metrics_constants.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Lost GPS metric that is used to track the number of times the GPS signal is lost.
class LostGpsMetrics {
  /// The time in milliseconds that the GPS signal was lost.
  /// Example: 1000 ms
  final int? duration;

  /// Location: latitude and longitude
  /// Example: [37.7749, 122.4194] or null
  /// If the location is null, the location is not available or the error occurred
  final List<double>? location;

  const LostGpsMetrics({
    this.location,
    this.duration,
  });

  /// Copy with method
  LostGpsMetrics copyWith({
    int? duration,
    List<double>? location,
  }) =>
      LostGpsMetrics(
        duration: duration ?? this.duration,
        location: location ?? this.location,
      );

  /// Convert the object to a Map
  Map<String, dynamic> toJson() => {
        AdvancedMetricsConstants.keys.lostGpsDuration: duration,
        AdvancedMetricsConstants.keys.location: location,
      };

  /// To save in shared preferences
  String toJsonString() => jsonEncode(toJson());
  Map<String, dynamic> fromJsonString(String jsonString) => jsonDecode(jsonString) as Map<String, dynamic>;

  /// Create a LostGpsMetrics object from a JSON map
  static LostGpsMetrics? fromJson(String jsonString) {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return LostGpsMetrics(
        duration: json[AdvancedMetricsConstants.keys.lostGpsDuration] as int?,
        location: (json[AdvancedMetricsConstants.keys.location] as List<dynamic>).map((e) => e as double).toList(),
      );
    } catch (e) {
      logger.log('LostGpsMetrics fromJson error: $e', logLevel: MapnessLogLevel.critical);
    }
    return null;
  }

  @override
  String toString() =>
      '${AdvancedMetricsConstants.debugConsole}::${AdvancedMetricsConstants.lostGps}: duration: $duration, location: $location';
}
