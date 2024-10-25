import 'dart:async';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/shared/constants/advanced_metrics_constants.dart';
import 'package:mapness/shared/lib/metrics/battery_usage.dart';
import 'package:mapness/shared/lib/metrics/load_time.dart';
import 'package:mapness/shared/lib/metrics/lost_gps.dart';
import 'package:mapness/shared/lib/metrics/route_calculation.dart';
import 'package:mapness/shared/lib/metrics/search_response_time.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
  LoadTimeMetrics? _loadTimeMetrics;

  void startMeasureStartup() {
    _startupMeasure = Stopwatch()..start();
  }

  Future<void> stopMeasureStartup({required TrackEvent track}) async {
    if (_startupMeasure != null) {
      final duration = _startupMeasure!.elapsedMilliseconds;
      _startupMeasure?.stop();
      _startupMeasure = null;
      try {
        _loadTimeMetrics = LoadTimeMetrics(
          loadTime: duration,
          deviceType: await getDeviceInfo(),
          appVersion: await _getAppVersion(),
          timestamp: _timeStamp,
          networkType: await Connectivity().checkConnectivity(),
          sessionId: _sessionUuid,
          location: await _getLocation(),
        );
        await track(
          AdvancedMetricsConstants.appLoadTime,
          properties: _loadTimeMetrics!.toJson(),
        );
        print(_loadTimeMetrics.toString());
      } catch (e) {
        print('${AdvancedMetricsConstants.debugConsole}::${AdvancedMetricsConstants.appLoadTime}: ${e.toString()}');
      }
    }
  }

  // Battery usage measurement
  Stopwatch? _appRuntime;
  Timer? _batteryTimer;
  final _batteryDuration = const Duration(seconds: 15);
  int? _batteryInitial;

  Future<void> sendPreviousSessionBatteryUsage({required TrackEvent track}) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final jsonString = sharedPrefs.getString(AdvancedMetricsConstants.batteryUsage);
    if (jsonString != null) {
      final metrics = BatteryUsage.fromJson(jsonString);
      try {
        await track(
          AdvancedMetricsConstants.batteryUsage,
          properties: metrics.toJson(),
        );
        await sharedPrefs.remove(AdvancedMetricsConstants.batteryUsage);
        print(metrics.toString());
      } catch (e) {
        print('${AdvancedMetricsConstants.debugConsole}::${AdvancedMetricsConstants.batteryUsage}::${e.toString()}');
      }
    }
  }

  Future<void> startMeasureBattery() async {
    _appRuntime = Stopwatch()..start();
    try {
      _batteryInitial = await Battery().batteryLevel;
    } catch (e) {
      print('${AdvancedMetricsConstants.debugConsole}::${AdvancedMetricsConstants.batteryUsage}::${e.toString()}');
      return;
    }
    await _measureBattery();

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
      try {
        level = await Battery().batteryLevel;
      } catch (e) {
        print('${AdvancedMetricsConstants.debugConsole}::${AdvancedMetricsConstants.batteryUsage}::${e.toString()}');
        return;
      }

      final levelDiff = _batteryInitial! - level;
      final batteryUsage = levelDiff / (duration / (1000 * 60));

      final batteryUsageMetrics = BatteryUsage(
        batteryUsage: batteryUsage,
        sessionDuration: duration.toDouble(),
        deviceType: await getDeviceInfo(),
        appVersion: await _getAppVersion(),
        timestamp: _timeStamp,
        networkType: await Connectivity().checkConnectivity(),
        location: await _getLocation(),
        activeProcesses: [],
        deviceState: await Battery().batteryState,
        isInBatterySaveMode: await Battery().isInBatterySaveMode,
        sessionId: _sessionUuid,
      );
      await _saveBatteryUsage(batteryUsageMetrics);
      print(batteryUsageMetrics.toString());
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
      deviceType: await getDeviceInfo(),
      appVersion: await _getAppVersion(),
      timestamp: _timeStamp,
      networkType: await Connectivity().checkConnectivity(),
      sessionId: _sessionUuid,
      location: await _getLocation(),
    );

    final sharedPrefs = await SharedPreferences.getInstance();
    if (_lostGpsLast != null) {
      final jsonString = _lostGpsLast!.toJsonString();
      await sharedPrefs.setString(_lostGpsKey, jsonString);
    }
    print(_lostGpsLast.toString());
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
      await track(
        AdvancedMetricsConstants.lostGps,
        properties: _lostGpsLast!.toJson(),
      );
      print(_lostGpsLast.toString());
      _lostGpsLast = null;
      await _lostGPSClean();
      return;
    }

    final sharedPrefs = await SharedPreferences.getInstance();
    final jsonString = sharedPrefs.getString(_lostGpsKey);
    if (jsonString != null) {
      final metrics = LostGpsMetrics.fromJson(jsonString);
      await track(
        AdvancedMetricsConstants.lostGps,
        properties: metrics.toJson(),
      );
      print(metrics.toString());
      await _lostGPSClean();
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
        deviceType: await getDeviceInfo(),
        appVersion: await _getAppVersion(),
        timestamp: _timeStamp,
        networkType: await Connectivity().checkConnectivity(),
        sessionId: _sessionUuid,
      );
      await track(
        AdvancedMetricsConstants.routeCalculationTime,
        properties: routeCalculation.toJson(),
      );
      print(routeCalculation.toString());
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

      final searchResponse = SearchResponseTimeMetric(
        responseTime: duration,
        query: _searchQuery!,
        searchQuery: _searchQueryType!,
        deviceType: await getDeviceInfo(),
        appVersion: await _getAppVersion(),
        timestamp: _timeStamp,
        networkType: await Connectivity().checkConnectivity(),
        sessionId: _sessionUuid,
      );
      await track(
        AdvancedMetricsConstants.searchDuration,
        properties: searchResponse.toJson(),
      );
      print(searchResponse.toString());
    }
  }

  // General
  Future<String> getDeviceInfo() async {
    if (_deviceInfo != null) {
      return _deviceInfo!;
    }
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final deviceInfo = await deviceInfoPlugin.iosInfo;
      _deviceInfo = '${deviceInfo.name} ${deviceInfo.systemVersion}';
    } else {
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      _deviceInfo = '${deviceInfo.model} ${deviceInfo.version}';
    }
    return _deviceInfo!;
  }

  Future<String> _getAppVersion() async {
    if (_appVersion != null) {
      return _appVersion!;
    }
    final platformInfo = await PackageInfo.fromPlatform();
    _appVersion = '${platformInfo.version}(${platformInfo.buildNumber})';
    return _appVersion!;
  }

  String get _timeStamp => DateTime.now().toUtc().toIso8601String();

  Future<List<double>?> _getLocation() async {
    try {
      final location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(milliseconds: 300),
      );
      return [location.latitude, location.longitude];
    } catch (e) {
      print('${AdvancedMetricsConstants.debugConsole}::Location: ${e.toString()}');
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
