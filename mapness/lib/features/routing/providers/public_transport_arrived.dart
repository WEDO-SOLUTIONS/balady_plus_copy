import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'public_transport_arrived.g.dart';

/// Configuration constants for arrival detection
class ArrivalConfig {
  static const Duration checkInterval = Duration(seconds: 30);
  static const double arrivalThresholdMeters = 100.0;
  static const double metersPerKilometer = 1000.0;
}

/// Provider that monitors user arrival at public transport destinations.
///
/// Checks user location every 30 seconds and determines if they have arrived
/// within 100 meters of the final destination.
@riverpod
class PublicTransportArrived extends _$PublicTransportArrived {
  Timer? _arrivalCheckTimer;

  @override
  Future<bool> build({
    required (double?, double?) destination,
  }) async {
    final hasArrived = await _checkUserArrival();

    if (!hasArrived) {
      _startArrivalMonitoring();
    }

    ref.onDispose(() {
      _stopArrivalMonitoring();
    });

    return hasArrived;
  }

  /// Starts periodic arrival monitoring
  void _startArrivalMonitoring() {
    _arrivalCheckTimer?.cancel();
    _arrivalCheckTimer = Timer.periodic(
      ArrivalConfig.checkInterval,
      (_) => _performArrivalCheck(),
    );
  }

  /// Performs a single arrival check
  Future<void> _performArrivalCheck() async {
    try {
      final hasArrived = await _checkUserArrival();
      if (hasArrived && !state.isLoading) {
        state = const AsyncValue.data(true);
        _stopArrivalMonitoring();
      }
    } catch (error) {
      debugPrint('Error during arrival check: $error');
      // Don't update state on error to avoid disrupting UI
    }
  }

  /// Checks if user has arrived at destination
  Future<bool> _checkUserArrival() async {
    final currentLocation = ref.read(locationProvider);
    if (currentLocation == null) {
      return false;
    }

    final (destLat, destLon) = destination;
    if (destLat == null || destLon == null) {
      // If destination is null, assume user is at their location
      return true;
    }

    final distanceInMeters = _calculateDistanceInMeters(
      currentLocation.latitude,
      currentLocation.longitude,
      destLat,
      destLon,
    );

    debugPrint('Distance to destination: ${distanceInMeters.toStringAsFixed(2)} meters');

    return distanceInMeters <= ArrivalConfig.arrivalThresholdMeters;
  }

  /// Calculates distance between two points in meters
  double _calculateDistanceInMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final distanceInKm = CommonFunctions.distance(lat1, lon1, lat2, lon2);
    return distanceInKm * ArrivalConfig.metersPerKilometer;
  }

  /// Stops arrival monitoring
  void _stopArrivalMonitoring() {
    _arrivalCheckTimer?.cancel();
    _arrivalCheckTimer = null;
  }

  /// Manually triggers an immediate arrival check
  Future<void> checkArrivalNow() async {
    await _performArrivalCheck();
  }

  /// Stops automatic arrival monitoring
  void stopMonitoring() {
    _stopArrivalMonitoring();
  }

  /// Restarts automatic arrival monitoring
  void restartMonitoring() {
    _startArrivalMonitoring();
  }
}
