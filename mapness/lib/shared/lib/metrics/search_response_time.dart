import 'package:connectivity_plus/connectivity_plus.dart';

class SearchResponseTimeMetric {
  /// A value in milliseconds indicating how long it took to return search results.
  /// Example: 1000
  final int responseTime;

  /// Query used to search.
  /// Specifies the type of search (for example, search by address, by objects, by category).
  /// Example: "search by address"
  final String query;

  /// Text entered by the user in the search bar to analyze the frequency and types of queries.
  final String searchQuery;

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

  const SearchResponseTimeMetric({
    required this.responseTime,
    required this.query,
    required this.searchQuery,
    required this.deviceType,
    required this.appVersion,
    required this.timestamp,
    required this.networkType,
    required this.sessionId,
  });
}
