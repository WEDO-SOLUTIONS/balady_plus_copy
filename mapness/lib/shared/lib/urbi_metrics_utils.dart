class UrbiMetricsUtils {
  static String testKey = 'measure_startup_time';
  static final UrbiMetricsUtils _singleton = UrbiMetricsUtils._internal();

  factory UrbiMetricsUtils() => _singleton;

  UrbiMetricsUtils._internal();

  final Map<String, Stopwatch> _timers = {};

  void startTimeMeasure(String key) {
    if (!_timers.containsKey(key)) {
      _timers[key] = Stopwatch();
    }
    _timers[key]?.stop();
    _timers[key]?.start();
  }

  int? stopAndGetTime(String key) {
    int? result;
    if (_timers.containsKey(key)) {
      result = _timers[key]?.elapsedMilliseconds;
      _timers[key]?.stop();
    }
    return result;
  }
}
