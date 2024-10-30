class AdvancedMetricsConstants {
  const AdvancedMetricsConstants();

  /// Metric that measures the time it takes for the app to load
  /// Also we need to add additional information about the device and session
  static String get appLoadTime => 'app_load_time';

  /// Metric that measures the battery usage of the app
  /// Also we need to add additional information about the device and session
  static String get batteryUsage => 'battery_usage';

  /// Metric that measures the amount and duration of GPS lost signals
  static String get lostGps => 'lost_gps';

  /// Metric that measures the duration of the search response
  static String get searchDuration => 'search_duration';

  /// Metric that measures the route calculation time
  static String get routeCalculationTime => 'route_calculation_time';

  /// The analytics key for debug console
  static String get debugConsole => 'Analytics';

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
  String get sessionDuration => 'session_duration';
  String get activeProcesses => 'active_processes';
  String get deviceState => 'device_battery_state';
  String get isInBatterySaveMode => 'is_in_battery_save_mode';

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
  String get location => 'location';
}
