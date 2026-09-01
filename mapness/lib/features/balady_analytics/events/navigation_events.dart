import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/features/balady_analytics/balady_analytics.dart';

/// Free roam entry points, reported as the `source` property of
/// `free_roam_started` (docs/analytics-tracking-plan.md, Phase 1 / Navigator).
enum BaladyFreeRoamSource { dashboard, autostart, carplay }

/// Phase-1 navigator events of the Balady tracking plan
/// (docs/analytics-tracking-plan.md). All navigator event names live in this
/// file only; call sites pass raw domain data and this class shapes it into
/// PostHog properties (snake_case, numerics as numbers, no exact coordinates).
class BaladyNavigationEvents {
  BaladyNavigationEvents._();

  // Event names are immutable — see the tracking plan before changing anything.
  static const _routeBuiltName = 'route_built';
  static const _routeFailedName = 'route_failed';
  static const _navigationStartedName = 'navigation_started';
  static const _navigationCompletedName = 'navigation_completed';
  static const _navigationCancelledName = 'navigation_cancelled';
  static const _freeRoamStartedName = 'free_roam_started';
  static const _carplayConnectedName = 'carplay_connected';
  static const _androidAutoConnectedName = 'android_auto_connected';

  /// `transport_mode` property value for a route search type.
  static String transportMode(RouteSearchOptionsMessage navType) =>
      navType == RouteSearchOptionsMessage.publicTransport ? 'transit' : navType.name;

  /// `distance_bucket` property value for a route length in meters.
  static String distanceBucket(double meters) {
    if (meters < 1000) {
      return '<1km';
    }
    if (meters <= 5000) {
      return '1-5km';
    }
    if (meters <= 20000) {
      return '5-20km';
    }
    return '>20km';
  }

  // --- Destination district (from already-loaded directory objects only) ---

  static const _districtCacheLimit = 32;

  /// objectId -> district name, populated from directory objects the app has
  /// already loaded on the way to route building (POI card, routing search).
  static final Map<int, String> _districtByObjectId = {};

  /// Remember the destination's district from an already-loaded search/POI
  /// [DirectoryObjectMessage] so `route_built` can report it. Never triggers
  /// any lookup: arbitrary map points simply stay without a district.
  /// Mirrors the `address.drilldown` parsing of `make_address.dart`.
  static void rememberRouteDestination(DirectoryObjectMessage? object) {
    final objectId = object?.id?.objectId;
    if (objectId == null) {
      return;
    }
    final district = object?.address?.drilldown.firstWhereOrNull((element) => element.type == 'district')?.name;
    if (district == null || district.isEmpty) {
      return;
    }
    if (_districtByObjectId.length >= _districtCacheLimit && !_districtByObjectId.containsKey(objectId)) {
      _districtByObjectId.remove(_districtByObjectId.keys.first);
    }
    _districtByObjectId[objectId] = district;
  }

  // --- City resolution (same source as the legacy navigation events) ---

  /// Rounded lat/lng -> city name, so repeated route recalculations between
  /// the same endpoints do not re-hit the geocoder used by the legacy events.
  static final Map<String, String> _cityCache = {};

  static Future<String?> _cityFor(
    double? lat,
    double? lng,
    Future<String?> Function(double lat, double lng) resolveCityName,
  ) async {
    if (lat == null || lng == null) {
      return null;
    }
    // ~1 km precision is plenty for city granularity.
    final key = '${lat.toStringAsFixed(2)},${lng.toStringAsFixed(2)}';
    final cached = _cityCache[key];
    if (cached != null) {
      return cached;
    }
    final name = await resolveCityName(lat, lng);
    if (name != null && name.isNotEmpty) {
      _cityCache[key] = name;
    }
    return name;
  }

  // --- route_built / route_failed ---

  /// Route calculated and shown. Cities are resolved asynchronously through
  /// [resolveCityName] (the same city-by-location source the legacy
  /// `navigationStarted` events used) and the event is sent fire-and-forget.
  static void trackRouteBuilt({
    required RouteSearchOptionsMessage navType,
    required double? originLat,
    required double? originLng,
    required double? destinationLat,
    required double? destinationLng,
    required int alternativesCount,
    required Future<String?> Function(double lat, double lng) resolveCityName,
    int? destinationObjectId,
    double? distanceM,
  }) {
    unawaited(
      () async {
        String? originCity;
        String? destinationCity;
        try {
          originCity = await _cityFor(originLat, originLng, resolveCityName);
          destinationCity = await _cityFor(destinationLat, destinationLng, resolveCityName);
        } catch (_) {
          // City resolution must never block or fail the event.
        }
        BaladyAnalytics.instance.track(
          _routeBuiltName,
          properties: {
            'transport_mode': transportMode(navType),
            'origin_city': originCity,
            'destination_city': destinationCity,
            'district': destinationObjectId == null ? null : _districtByObjectId[destinationObjectId],
            if (distanceM != null) 'distance_m': distanceM.round(),
            if (distanceM != null) 'distance_bucket': distanceBucket(distanceM),
            'alternatives_count': alternativesCount,
          },
        );
      }(),
    );
  }

  /// Route calculation failed. [error] is reduced to a short reason string —
  /// never coordinates or any other PII.
  static void trackRouteFailed({required RouteSearchOptionsMessage navType, required Object error}) {
    BaladyAnalytics.instance.track(
      _routeFailedName,
      properties: {'transport_mode': transportMode(navType), 'reason': _failureReason(error)},
    );
  }

  static String _failureReason(Object error) {
    if (error is TimeoutException) {
      return 'timeout';
    }
    // Matched by type name to avoid importing the routing provider here.
    final type = error.runtimeType.toString();
    return switch (type) {
      'NoInternetException' => 'no_internet',
      'WalkingDistanceException' => 'walking_distance_limit',
      _ => type,
    };
  }

  // --- navigation lifecycle ---

  static _TripState? _trip;

  /// Guidance started. Captures planned distance/ETA so the trip-end event can
  /// report `eta_error_sec` and completion thresholds later.
  static void trackNavigationStarted({
    required RouteSearchOptionsMessage navType,
    required bool carConnected,
    double? plannedDistanceM,
    int? plannedDurationSec,
  }) {
    _trip = _TripState(
      startedAt: DateTime.now(),
      plannedDistanceM: plannedDistanceM,
      plannedDurationSec: plannedDurationSec,
    );
    BaladyAnalytics.instance.track(
      _navigationStartedName,
      properties: {
        'transport_mode': transportMode(navType),
        if (plannedDistanceM != null) 'distance_bucket': distanceBucket(plannedDistanceM),
        'head_unit': !carConnected
            ? 'none'
            : Platform.isIOS
            ? 'carplay'
            : 'android_auto',
      },
    );
  }

  /// A route recalculation happened during active guidance.
  static void trackReroute() {
    _trip?.reroutesCount++;
  }

  /// Guidance ended — decides between `navigation_completed` and
  /// `navigation_cancelled` per the tracking plan: a manual stop still counts
  /// as completed when progress >= 90% OR remaining <= min(200 m, 20% of the
  /// route length); [arrivedDetected] short-circuits as `arrived`.
  static void trackNavigationEnded({
    required RouteSearchOptionsMessage navType,
    required bool arrivedDetected,
    double? plannedDistanceM,
    int? plannedDurationSec,
    double? remainingDistanceM,
    Duration? spentTime,
  }) {
    final trip = _trip;
    _trip = null;

    final planned = trip?.plannedDistanceM ?? plannedDistanceM;
    final plannedSec = trip?.plannedDurationSec ?? plannedDurationSec;
    final durationSec = trip != null ? DateTime.now().difference(trip.startedAt).inSeconds : spentTime?.inSeconds;

    double? progress; // 0..1, null when unknown.
    if (arrivedDetected) {
      progress = 1;
    } else if (planned != null && planned > 0 && remainingDistanceM != null) {
      progress = ((planned - remainingDistanceM) / planned).clamp(0.0, 1.0);
    }

    final completed = arrivedDetected || _manualStopCountsAsCompleted(planned: planned, remaining: remainingDistanceM);

    if (completed) {
      BaladyAnalytics.instance.track(
        _navigationCompletedName,
        properties: {
          'transport_mode': transportMode(navType),
          'end_reason': arrivedDetected ? 'arrived' : 'manual_stop',
          if (durationSec != null) 'duration_sec': durationSec,
          if (planned != null) 'distance_m': planned.round(),
          if (durationSec != null && plannedSec != null) 'eta_error_sec': durationSec - plannedSec,
          if (trip != null) 'reroutes_count': trip.reroutesCount,
        },
      );
    } else {
      BaladyAnalytics.instance.track(
        _navigationCancelledName,
        properties: {
          'transport_mode': transportMode(navType),
          if (progress != null) 'progress_pct': (progress * 100).round(),
          if (durationSec != null) 'duration_sec': durationSec,
        },
      );
    }
  }

  static bool _manualStopCountsAsCompleted({double? planned, double? remaining}) {
    if (planned == null || planned <= 0 || remaining == null) {
      return false;
    }
    if ((planned - remaining) / planned >= 0.9) {
      return true;
    }
    return remaining <= math.min(200.0, planned * 0.2);
  }

  // --- free roam / head units ---

  /// `FreeRoamRoute` pushed — free roam entered from [source].
  static void trackFreeRoamStarted(BaladyFreeRoamSource source) {
    BaladyAnalytics.instance.track(_freeRoamStartedName, properties: {'source': source.name});
  }

  /// Head unit session attached — CarPlay on iOS, Android Auto on Android
  /// (the platform decides which projection a phone can host).
  static void trackHeadUnitConnected() {
    BaladyAnalytics.instance.track(Platform.isIOS ? _carplayConnectedName : _androidAutoConnectedName);
  }
}

class _TripState {
  _TripState({required this.startedAt, this.plannedDistanceM, this.plannedDurationSec});

  final DateTime startedAt;
  final double? plannedDistanceM;
  final int? plannedDurationSec;
  int reroutesCount = 0;
}
