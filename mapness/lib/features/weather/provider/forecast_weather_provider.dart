import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/entities/weather/weather_info.dart';
import 'package:mapness/features/weather/data/repository/weather_repository.dart';
import 'package:mapness/features/weather/data/weather_forecast_cache.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/app_settled.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'forecast_weather_provider.g.dart';

/// Forecast for the map weather chip and the weather page; `null` until the first forecast is known.
///
/// The chip is glanceable and rarely tapped, so the forecast is requested as seldom as possible and never
/// competes with the landing start-up:
/// - nothing is requested before the app has settled ([whenAppSettled]);
/// - a forecast is reused for [_ttl], across app restarts too ([WeatherForecastCache]);
/// - panning refetches only after moving more than [_refetchDistanceMeters] away (another city);
/// - a failed request is not retried for [_failureCooldown], and the last good forecast stays on screen;
/// - no failure escapes: errors are logged, never rethrown.
///
/// [forceRefresh] is the user-initiated path (weather page retry) and skips all of the above.
@Riverpod(keepAlive: true)
class _ForecastWeather extends _$ForecastWeather {
  static const _ttl = Duration(hours: 1);

  /// A cached forecast older than this is not shown at all, not even while a fresh one loads.
  static const _maxDisplayAge = Duration(hours: 3);
  static const _failureCooldown = Duration(minutes: 10);
  static const _refetchDistanceMeters = 50000.0;
  static const _numberOfDays = 5;

  WeatherForecastSnapshot? _snapshot;
  DateTime? _lastFailureAt;
  Future<void>? _inFlight;
  CancelToken? _cancelToken;

  @override
  AllWeatherInfoEntity? build() {
    final controller = ref.watch(dgisControllerProvider).value;
    // Keep the repository (auto-dispose) alive without rebuilding the forecast when it changes.
    ref.listen(weatherRepository, (_, _) {});

    _snapshot = null;
    _lastFailureAt = null;
    _inFlight = null;
    final cancelToken = _cancelToken = CancelToken();

    StreamSubscription<CameraPositionMessage>? cameraSubscription;
    Timer? ttlTimer;
    AppLifecycleListener? lifecycleListener;
    ref.onDispose(() {
      cancelToken.cancel();
      cameraSubscription?.cancel();
      ttlTimer?.cancel();
      lifecycleListener?.dispose();
    });

    if (controller == null) {
      return null;
    }

    unawaited(
      _guard(() async {
        await whenAppSettled();
        if (!_isCurrent(cancelToken)) {
          return;
        }
        await _restoreFromDisk(cancelToken);
        await _refreshIfNeeded(controller, cancelToken);
        if (!_isCurrent(cancelToken)) {
          return;
        }

        cameraSubscription = controller.cameraPositionEvents
            .debounceTime(const Duration(seconds: 1))
            .listen((position) => unawaited(_guard(() => _refreshIfNeeded(controller, cancelToken, position))));
        // Covers a map left untouched for longer than the TTL; a no-op while the forecast is fresh.
        ttlTimer = Timer.periodic(_ttl, (_) => unawaited(_guard(() => _refreshIfNeeded(controller, cancelToken))));
        lifecycleListener = AppLifecycleListener(
          onResume: () => unawaited(_guard(() => _refreshIfNeeded(controller, cancelToken))),
        );
      }),
    );

    return null;
  }

  /// Requests a fresh forecast right away, ignoring the TTL, the cooldown and the start-up gate.
  Future<void> forceRefresh() => _guard(() async {
    final cancelToken = _cancelToken;
    final controller = ref.read(dgisControllerProvider).value;
    if (cancelToken == null || controller == null || !_isCurrent(cancelToken)) {
      return;
    }
    final position = await controller.getCameraPosition();
    if (_isCurrent(cancelToken)) {
      await _fetch(position, cancelToken);
    }
  });

  bool _isCurrent(CancelToken cancelToken) => ref.mounted && !cancelToken.isCancelled;

  String get _languageCode => ref.read(appLanguageProvider).locale.languageCode;

  Future<void> _restoreFromDisk(CancelToken cancelToken) async {
    final snapshot = await WeatherForecastCache.read();
    if (snapshot == null || !_isCurrent(cancelToken) || _snapshot != null) {
      return;
    }
    if (snapshot.languageCode != _languageCode || snapshot.age > _maxDisplayAge) {
      return;
    }
    final forecast = forecastFromPayload(snapshot.payload);
    if (forecast == null) {
      return;
    }
    _snapshot = snapshot;
    state = forecast;
  }

  Future<void> _refreshIfNeeded(
    DgisMapController controller,
    CancelToken cancelToken, [
    CameraPositionMessage? position,
  ]) async {
    final lifecycleState = WidgetsBinding.instance.lifecycleState;
    if (_inFlight != null || (lifecycleState != null && lifecycleState != AppLifecycleState.resumed)) {
      return;
    }
    final lastFailureAt = _lastFailureAt;
    if (lastFailureAt != null && DateTime.now().difference(lastFailureAt) < _failureCooldown) {
      return;
    }

    final camera = position ?? await controller.getCameraPosition();
    if (!_isCurrent(cancelToken) || !_needsRefresh(camera)) {
      return;
    }
    await _fetch(camera, cancelToken);
  }

  bool _needsRefresh(CameraPositionMessage camera) {
    final snapshot = _snapshot;
    if (snapshot == null || snapshot.languageCode != _languageCode || snapshot.age >= _ttl) {
      return true;
    }
    final distance = Geolocator.distanceBetween(
      snapshot.latitude,
      snapshot.longitude,
      camera.point.latitude,
      camera.point.longitude,
    );
    return distance > _refetchDistanceMeters;
  }

  /// Runs at most one request at a time; a concurrent call joins the running one.
  Future<void> _fetch(CameraPositionMessage camera, CancelToken cancelToken) {
    final running = _inFlight;
    if (running != null) {
      return running;
    }
    final request = _request(camera, cancelToken);
    _inFlight = request;
    return request.whenComplete(() {
      if (identical(_inFlight, request)) {
        _inFlight = null;
      }
    });
  }

  Future<void> _request(CameraPositionMessage camera, CancelToken cancelToken) async {
    final latitude = camera.point.latitude;
    final longitude = camera.point.longitude;
    final languageCode = _languageCode;

    Map<String, dynamic>? payload;
    try {
      payload = await ref
          .read(weatherRepository.notifier)
          .fetchForecastPayload(
            latitude: latitude,
            longitude: longitude,
            numberOfDays: _numberOfDays,
            cancelToken: cancelToken,
          );
    } on Object catch (error) {
      if (cancelToken.isCancelled || (error is DioException && CancelToken.isCancel(error))) {
        return;
      }
      logger.log('Weather forecast request failed: $error', logLevel: MapnessLogLevel.error);
    }
    if (!_isCurrent(cancelToken)) {
      return;
    }

    final forecast = payload == null ? null : forecastFromPayload(payload);
    if (payload == null || forecast == null) {
      // Keep whatever is on screen; try again after the cooldown.
      _lastFailureAt = DateTime.now();
      return;
    }

    final snapshot = WeatherForecastSnapshot(
      latitude: latitude,
      longitude: longitude,
      fetchedAt: DateTime.now(),
      languageCode: languageCode,
      payload: payload,
    );
    _lastFailureAt = null;
    _snapshot = snapshot;
    state = forecast;
    unawaited(_guard(() => WeatherForecastCache.write(snapshot)));
  }

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } on Object catch (error, stackTrace) {
      if (error is DioException && CancelToken.isCancel(error)) {
        return;
      }
      logger.log('Weather forecast: $error\n$stackTrace', logLevel: MapnessLogLevel.error);
    }
  }
}

final forecastWeatherProvider = _forecastWeatherProvider;
