class AdvancedMetricsConstants {
  const AdvancedMetricsConstants();

  /// Metric that measures the time it takes for the app to load
  /// Also we need to add additional information about the device and session
  static String get appLoadTime => 'App Load Time';

  /// Metric that measures the battery usage of the app
  /// Also we need to add additional information about the device and session
  static String get batteryUsage => 'Battery Usage';

  /// Metric that measures the amount and duration of GPS lost signals
  static String get lostGps => 'Lost GPS';

  /// Metric that measures the duration of the search response
  static String get searchResponseDuration => 'Search Response Duration';

  /// Metric that measures the route calculation time
  static String get routeCalculationTime => 'Route Calculation Time';

  static const keys = _AdvancedMetricsKeys();
}

class _AdvancedMetricsKeys {
  const _AdvancedMetricsKeys();

  // Startup
  String get loadTime => 'load_time';
  String get loadType => 'load_type';

  // Battery
  String get batteryUsage => 'battery_usage';
  // Time during the app is running
  String get appRuntime => 'app_runtime';
  String get activeProcesses => 'active_processes';
  String get deviceState => 'device_battery_state';

  // Navi: Lost GPS
  String get lostGpsDuration => 'lost_gps_duration';

  // Search
  String get searchResponseDuration => 'search_response_duration';
  String get searchQueryType => 'search_query_type';
  String get searchQueryValue => 'search_query_value';

  // Route
  String get routeCalculationTime => 'route_calculation_time';
  String get startAndEndPoints => 'route_start_and_end_points';
  String get errorCount => 'route_error_count';

  // General
  String get deviceType => 'device_type';
  String get appVersion => 'app_version';
  String get timestamp => 'timestamp';
  String get networkType => 'network_type';
  String get sessionId => 'session_id';
  String get location => 'location';
}
