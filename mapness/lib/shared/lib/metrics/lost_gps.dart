import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mapness/shared/constants/advanced_metrics_constants.dart';

/// Lost GPS metric that is used to track the number of times the GPS signal is lost.
class LostGpsMetrics {
  /// The time in milliseconds that the GPS signal was lost.
  /// Example: 1000 ms
  final int? duration;

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

  const LostGpsMetrics({
    required this.deviceType,
    required this.appVersion,
    required this.timestamp,
    required this.networkType,
    required this.sessionId,
    required this.location,
    this.duration,
  });

  /// Copy with method
  LostGpsMetrics copyWith({
    int? duration,
    String? deviceType,
    String? appVersion,
    String? timestamp,
    ConnectivityResult? networkType,
    String? sessionId,
    List<double>? location,
  }) =>
      LostGpsMetrics(
        duration: duration ?? this.duration,
        deviceType: deviceType ?? this.deviceType,
        appVersion: appVersion ?? this.appVersion,
        timestamp: timestamp ?? this.timestamp,
        networkType: networkType ?? this.networkType,
        sessionId: sessionId ?? this.sessionId,
        location: location ?? this.location,
      );

  /// Convert the object to a Map
  Map<String, dynamic> toJson() => {
        AdvancedMetricsConstants.keys.lostGpsDuration: duration,
        AdvancedMetricsConstants.keys.deviceType: deviceType,
        AdvancedMetricsConstants.keys.appVersion: appVersion,
        AdvancedMetricsConstants.keys.timestamp: timestamp,
        AdvancedMetricsConstants.keys.networkType: networkType.name,
        AdvancedMetricsConstants.keys.sessionId: sessionId,
        AdvancedMetricsConstants.keys.location: location,
      };

  /// To save in shared preferences
  String toJsonString() => jsonEncode(toJson());
  Map<String, dynamic> fromJsonString(String jsonString) => jsonDecode(jsonString) as Map<String, dynamic>;

  /// Create a LostGpsMetrics object from a JSON map
  factory LostGpsMetrics.fromJson(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return LostGpsMetrics(
      duration: json[AdvancedMetricsConstants.keys.lostGpsDuration] as int?,
      deviceType: json[AdvancedMetricsConstants.keys.deviceType] as String,
      appVersion: json[AdvancedMetricsConstants.keys.appVersion] as String,
      timestamp: json[AdvancedMetricsConstants.keys.timestamp] as String,
      networkType: ConnectivityResult.values
          .firstWhere((element) => element.name == json[AdvancedMetricsConstants.keys.networkType] as String),
      sessionId: json[AdvancedMetricsConstants.keys.sessionId] as String,
      location: (json[AdvancedMetricsConstants.keys.location] as List<dynamic>).map((e) => e as double).toList(),
    );
  }

  @override
  String toString() =>
      'LostGps: duration: $duration, deviceType: $deviceType, appVersion: $appVersion, timestamp: $timestamp, networkType: $networkType, sessionId: $sessionId, location: $location';
}
