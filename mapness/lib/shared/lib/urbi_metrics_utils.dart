import 'dart:developer';
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
        log('>>> $_loadTimeMetrics');
      } catch (e) {
        log('Log event failed: $e');
      }
    }
  }

  // Battery usage measurement
  final _battery = Battery();
  Stopwatch? _appRuntime;
  int? _batteryInitial;

  Future<void> startMeasureBattery() async {
    _appRuntime = Stopwatch()..start();
    _batteryInitial = await _battery.batteryLevel;
  }

  Future<void> stopMeasureBattery({required TrackEvent track}) async {
    if (_appRuntime != null && _batteryInitial != null) {
      final duration = _appRuntime!.elapsedMilliseconds;
      _appRuntime?.stop();
      _appRuntime = null;
      int level = -1;
      try {
        level = await _battery.batteryLevel;
      } catch (e) {
        log(e.toString());
        return;
      }

      final levelDiff = level - _batteryInitial!;
      final batteryUsage = levelDiff / duration;

      final batteryUsageMetrics = BatteryUsage(
        batteryUsage: batteryUsage,
        appRuntime: duration.toDouble(),
        deviceType: await getDeviceInfo(),
        appVersion: await _getAppVersion(),
        timestamp: _timeStamp,
        networkType: await Connectivity().checkConnectivity(),
        location: await _getLocation(),
        activeProcesses: [],
        deviceState: await _battery.batteryState,
      );
      await track(
        AdvancedMetricsConstants.batteryUsage,
        properties: batteryUsageMetrics.toJson(),
      );
      log('>>> $batteryUsageMetrics');
    }
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
    log('>>> $_lostGpsLast');
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
      log('>>> $_lostGpsLast');
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
      log('>>> $metrics');
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
      log('>>> Route $routeCalculation');
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
        AdvancedMetricsConstants.searchResponseDuration,
        properties: searchResponse.toJson(),
      );
      log('>>> Search response time: $searchResponse');
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
      log(e.toString());
    }
    return null;
  }
}
