import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/shared/constants/advanced_metrics_constants.dart';
import 'package:mapness/shared/lib/metrics/battery_usage.dart';
import 'package:mapness/shared/lib/metrics/load_time.dart';
import 'package:mapness/shared/lib/metrics/lost_gps.dart';
import 'package:mapness/shared/lib/metrics/route_calculation.dart';
import 'package:mapness/shared/lib/metrics/search_response_time.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

typedef TrackEvent = Future<dynamic> Function(String event, {Map<String, dynamic>? properties});

class AdvancedMetrics {
  AdvancedMetrics._privateConstructor();

  static final AdvancedMetrics _instance = AdvancedMetrics._privateConstructor();

  static AdvancedMetrics get instance => _instance;

  // General
  // Session id
  final _sessionUuid = const Uuid().v4();
  String get sessionId => _sessionUuid;

  String? _deviceInfo;
  String? get deviceInfo => _deviceInfo;

  String? _appVersion;
  String? get appVersion => _appVersion;

  // Startup time measurement
  Stopwatch? _startupMeasure;
  LoadType? _loadType;
  LoadTimeMetrics? _loadTimeMetrics;

  void startMeasureStartup([LoadType? type]) {
    _loadType ??= type;
    _startupMeasure ??= Stopwatch()..start();
  }

  Future<void> stopMeasureStartup({required TrackEvent track}) async {
    if (_startupMeasure != null) {
      final duration = _startupMeasure!.elapsedMilliseconds;
      _startupMeasure?.stop();
      _startupMeasure = null;
      try {
        _loadTimeMetrics = LoadTimeMetrics(
          loadTime: duration,
          loadType: _loadType ?? LoadType.unknown,
          location: await _getLocation(),
        );
        await track(
          AdvancedMetricsConstants.appLoadTime,
          properties: _loadTimeMetrics!.toJson(),
        );
        logger.log(_loadTimeMetrics.toString());
      } catch (e) {
        logger.log(
          '${AdvancedMetricsConstants.debugConsole}::${AdvancedMetricsConstants.appLoadTime}: ${e.toString()}',
          logLevel: MapnessLogLevel.critical,
        );
      }
    }
  }

  // Battery usage measurement
  Stopwatch? _appRuntime;
  Timer? _batteryTimer;
  static const _batteryDuration = Duration(seconds: 10);
  int? _batteryInitial;

  Future<void> sendPreviousSessionBatteryUsage({required TrackEvent track}) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final jsonString = sharedPrefs.getString(AdvancedMetricsConstants.batteryUsage);
    if (jsonString != null) {
      final metrics = BatteryUsage.fromJson(jsonString);
      if (metrics != null) {
        try {
          await track(
            AdvancedMetricsConstants.batteryUsage,
            properties: metrics.toJson(),
          );
          await sharedPrefs.remove(AdvancedMetricsConstants.batteryUsage);
          logger.log(metrics.toString());
        } catch (e) {
          logger.log(
            '${AdvancedMetricsConstants.debugConsole}::${AdvancedMetricsConstants.batteryUsage}::${e.toString()}',
            logLevel: MapnessLogLevel.critical,
          );
        }
      }
    }
  }

  Future<void> startMeasureBattery() async {
    _appRuntime = Stopwatch()..start();
    try {
      _batteryInitial = await Battery().batteryLevel;
    } catch (e) {
      logger.log('${AdvancedMetricsConstants.debugConsole}::${AdvancedMetricsConstants.batteryUsage}::${e.toString()}');
      return;
    }
    // Never let a metrics failure escape: this is awaited from the entry-point
    // init chain, and an escaped throw both killed the periodic timer below
    // and silently aborted everything after the call in entry_point.dart.
    try {
      await _measureBattery();
    } catch (e) {
      logger.log(
        '${AdvancedMetricsConstants.debugConsole}::${AdvancedMetricsConstants.batteryUsage}::${e.toString()}',
        logLevel: MapnessLogLevel.critical,
      );
    }

    _batteryTimer = Timer.periodic(_batteryDuration, (_) async {
      await _measureBattery();
    });
  }

  Future<void> pauseMeasureBattery() async {
    _appRuntime?.stop();
    _batteryTimer?.cancel();
    await _measureBattery();
  }

  Future<void> resumeMeasureBattery() async {
    _appRuntime?.start();
    await _measureBattery();
    _batteryTimer = Timer.periodic(_batteryDuration, (_) async {
      await _measureBattery();
    });
  }

  Future<void> _measureBattery() async {
    if (_appRuntime != null && _batteryInitial != null) {
      final duration = _appRuntime!.elapsedMilliseconds;
      int level = -1;
      BatteryState state = BatteryState.unknown;
      bool isInBatterySaveMode = false;
      try {
        level = await Battery().batteryLevel;
        state = await Battery().batteryState;
        isInBatterySaveMode = await Battery().isInBatterySaveMode;
      } catch (e) {
        logger.log(
          '${AdvancedMetricsConstants.debugConsole}::${AdvancedMetricsConstants.batteryUsage}::${e.toString()}',
          logLevel: MapnessLogLevel.critical,
        );
        return;
      }
      List<double>? location;
      try {
        location = await _getLocation();
      } catch (e) {
        logger.log(
          '${AdvancedMetricsConstants.debugConsole}::${AdvancedMetricsConstants.keys.location}::${e.toString()}',
          logLevel: MapnessLogLevel.critical,
        );
      }

      final minutes = duration / (1000 * 60);
      if (minutes <= 0) {
        // First sample lands sub-millisecond after start on fast devices:
        // elapsedMilliseconds is 0, and 0 / 0.0 = NaN, which jsonEncode can't
        // serialize. The sample carries no information anyway.
        return;
      }
      final batteryUsage = (_batteryInitial! - level) / minutes;
      if (!batteryUsage.isFinite) {
        return;
      }

      final batteryUsageMetrics = BatteryUsage(
        batteryUsage: batteryUsage,
        sessionDuration: duration.toDouble(),
        location: location,
        activeProcesses: [],
        deviceState: state,
        isInBatterySaveMode: isInBatterySaveMode,
      );
      await _saveBatteryUsage(batteryUsageMetrics);
    }
  }

  Future<void> _saveBatteryUsage(BatteryUsage metrics) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final jsonString = metrics.toJsonString();
    await sharedPrefs.setString(AdvancedMetricsConstants.batteryUsage, jsonString);
  }

  // Lost GPS
  LostGpsMetrics? _lostGpsLast;
  final _lostGpsKey = 'lost_gps';
  Stopwatch? _lostGpsRuntime;

  Future<void> addLostGPS() async {
    _lostGpsRuntime = Stopwatch()..start();
    _lostGpsLast = LostGpsMetrics(
      location: await _getLocation(),
    );

    final sharedPrefs = await SharedPreferences.getInstance();
    if (_lostGpsLast != null) {
      final jsonString = _lostGpsLast!.toJsonString();
      await sharedPrefs.setString(_lostGpsKey, jsonString);
    }
  }

  Future<void> addRestoreGPS({required TrackEvent track}) async {
    if (_lostGpsRuntime != null && _lostGpsLast != null) {
      final duration = _lostGpsRuntime!.elapsedMilliseconds;
      _lostGpsRuntime?.stop();
      _lostGpsRuntime = null;

      _lostGpsLast = _lostGpsLast!.copyWith(duration: duration);
      await sendLostGPS(track: track);
    }
  }

  Future<void> sendLostGPS({required TrackEvent track}) async {
    if (_lostGpsLast != null) {
      try {
        await track(
          AdvancedMetricsConstants.lostGps,
          properties: _lostGpsLast!.toJson(),
        );
        logger.log(_lostGpsLast.toString());
        _lostGpsLast = null;
        await _lostGPSClean();
        return;
      } catch (e) {
        logger.log(
          '${AdvancedMetricsConstants.debugConsole}::${AdvancedMetricsConstants.lostGps}::${e.toString()}',
          logLevel: MapnessLogLevel.critical,
        );
      }
    }

    final sharedPrefs = await SharedPreferences.getInstance();
    final jsonString = sharedPrefs.getString(_lostGpsKey);
    if (jsonString != null) {
      final metrics = LostGpsMetrics.fromJson(jsonString);
      if (metrics != null) {
        try {
          await track(
            AdvancedMetricsConstants.lostGps,
            properties: metrics.toJson(),
          );
          logger.log(metrics.toString());
          await _lostGPSClean();
        } catch (e) {
          logger.log(
            '${AdvancedMetricsConstants.debugConsole}::${AdvancedMetricsConstants.lostGps}::${e.toString()}',
            logLevel: MapnessLogLevel.critical,
          );
        }
      }
    }
  }

  Future<void> _lostGPSClean() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.remove(_lostGpsKey);
    _lostGpsLast = null;
  }

  // Route calculation time
  Stopwatch? _routeCalculationRuntime;
  final route = <List<double>>[];

  Future<void> startRouteCalculation(List<double>? start, List<double>? end) async {
    _routeCalculationRuntime = Stopwatch()..start();
    route
      ..clear()
      ..addAll([start ?? [], end ?? []]);
  }

  Future<void> stopRouteCalculation({required TrackEvent track}) async {
    if (_routeCalculationRuntime != null) {
      final duration = _routeCalculationRuntime!.elapsedMilliseconds;
      _routeCalculationRuntime?.stop();
      _routeCalculationRuntime = null;

      final routeCalculation = RouteCalculationMetrics(
        duration: duration,
        route: route,
      );
      try {
        await track(
          AdvancedMetricsConstants.routeCalculationTime,
          properties: routeCalculation.toJson(),
        );
        logger.log(routeCalculation.toString());
      } catch (e) {
        logger.log(
          '${AdvancedMetricsConstants.debugConsole}::${AdvancedMetricsConstants.routeCalculationTime}::${e.toString()}',
          logLevel: MapnessLogLevel.critical,
        );
      }
    }
  }

  // Search response time
  Stopwatch? _searchResponseRuntime;
  String? _searchQuery;
  String? _searchQueryType;

  void startSearchResponse({required String queryType, required String searchQuery}) {
    _searchResponseRuntime = Stopwatch()..start();
    _searchQuery = searchQuery;
    _searchQueryType = queryType;
  }

  Future<void> stopSearchResponse({required TrackEvent track}) async {
    if (_searchResponseRuntime != null && _searchQuery != null && _searchQueryType != null) {
      final duration = _searchResponseRuntime!.elapsedMilliseconds;
      _searchResponseRuntime?.stop();
      _searchResponseRuntime = null;

      // NB: `query` is the search TYPE, `searchQuery` is the user's text —
      // see SearchResponseTimeMetric field docs (they were swapped here before).
      final searchResponse = SearchResponseTimeMetric(
        responseTime: duration,
        query: _searchQueryType!,
        searchQuery: _searchQuery!,
      );
      try {
        await track(
          AdvancedMetricsConstants.searchDuration,
          properties: searchResponse.toJson(),
        );
        logger.log(searchResponse.toString());
      } catch (e) {
        logger.log(
          '${AdvancedMetricsConstants.debugConsole}::${AdvancedMetricsConstants.searchDuration}::${e.toString()}',
          logLevel: MapnessLogLevel.critical,
        );
      }
    }
  }

  // General
  static const _timeout = Duration(seconds: 2);
  Future<List<double>?> _getLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      final isGranded = await Permission.location.isGranted;

      if (!isGranded || !serviceEnabled) {
        return null;
      }
      final location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: _timeout,
      );
      return [location.latitude, location.longitude];
    } catch (e) {
      logger.log(
        '${AdvancedMetricsConstants.debugConsole}::Location: ${e.toString()}',
        logLevel: MapnessLogLevel.critical,
      );
    }
    return null;
  }

  void dispose() {
    _startupMeasure?.stop();
    _batteryTimer?.cancel();
    _appRuntime?.stop();
    _lostGpsRuntime?.stop();
    _routeCalculationRuntime?.stop();
    _searchResponseRuntime?.stop();
  }
}
