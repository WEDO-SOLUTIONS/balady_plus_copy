import 'dart:developer';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/shared/lib/metrics/battery_usage.dart';
import 'package:mapness/shared/lib/metrics/load_time.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

class UrbiMetricsUtils {
  UrbiMetricsUtils._privateConstructor();

  static final UrbiMetricsUtils _instance = UrbiMetricsUtils._privateConstructor();

  static UrbiMetricsUtils get instance => _instance;

  static String testKey = 'measure_startup_time';

  // Session id
  final _sessionUuid = const Uuid().v4();
  String get sessionUuid => _sessionUuid;

  // Battery level and state
  final battery = Battery();

  final Map<String, Stopwatch> _timers = {};
  (DateTime, int)? _batteryMeasureStart;

  Future<void> startBatteryMeasure() async {
    try {
      final level = await battery.batteryLevel;
      _batteryMeasureStart = (DateTime.now(), level);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> stopBatteryMeasure() async {
    if (_batteryMeasureStart != null) {
      final end = DateTime.now();
      final start = _batteryMeasureStart!.$1;
      final level = await battery.batteryLevel;
      final startLevel = _batteryMeasureStart!.$2;
      final duration = end.difference(start).inMilliseconds;
      final levelDiff = level - startLevel;
      log('>>> Battery measure: $duration ms, $levelDiff %');
      log('>>> Battery velocity: ${levelDiff / duration} %/ms');
    }
  }

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

  Future<void> stopMeasureStartup() async {
    if (_startupMeasure != null) {
      final duration = _startupMeasure!.elapsedMilliseconds;
      _startupMeasure?.stop();
      _startupMeasure = null;

      _loadTimeMetrics = LoadTimeMetrics(
        loadTime: duration,
        deviceType: await getDeviceInfo(),
        appVersion: await _getAppVersion(),
        timestamp: _timeStamp,
        networkType: await Connectivity().checkConnectivity(),
        sessionId: UrbiMetricsUtils.instance.sessionUuid,
        location: await _getLocation(),
      );
      log('>>> $_loadTimeMetrics');
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

  Future<void> stopMeasureBattery() async {
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
      log('>>> $batteryUsageMetrics');
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
    final platformInfo = await PackageInfo.fromPlatform();
    return '${platformInfo.version}(${platformInfo.buildNumber})';
  }

  String get _timeStamp => DateTime.now().toUtc().toIso8601String();

  Future<List<double>> _getLocation() async {
    final location = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
      timeLimit: const Duration(seconds: 1),
    );
    return [location.latitude, location.longitude];
  }
}
