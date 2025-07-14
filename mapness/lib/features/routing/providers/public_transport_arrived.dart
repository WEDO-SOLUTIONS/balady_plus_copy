import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'public_transport_arrived.g.dart';

/// Provider that checks every 30 seconds if the user has arrived at the final destination
/// of a public transport route.
@riverpod
class PublicTransportArrived extends _$PublicTransportArrived {
  Timer? _timer;
  static const _checkInterval = Duration(seconds: 30);
  static const _arrivalThreshold = 100.0; // 100 meters threshold for arrival

  @override
  Future<bool> build({
    required (double?, double?) destination,
  }) async {
    // Start the timer to check arrival every 30 seconds
    final hasArrived = await _isUserAtDestination();
    if (!hasArrived) {
      _startTimer();
    }
    // Return false initially (not arrived yet)
    return hasArrived;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(_checkInterval, (_) => _checkArrival());
  }

  Future<void> _checkArrival() async {
    try {
      final hasArrived = await _isUserAtDestination();
      if (hasArrived && !state.isLoading) {
        state = const AsyncValue.data(true);
        _stopTimer();
      }
    } catch (e) {
      debugPrint('Error checking arrival: $e');
    }
  }

  Future<bool> _isUserAtDestination() async {
    // Get current user location
    final currentLocation = ref.read(locationProvider);
    if (currentLocation == null) {
      return false;
    }

    // Get the final destination coordinates
    if (destination.$1 == null || destination.$2 == null) {
      // Because if destination is null, this is my location
      return true;
    }

    // Calculate distance between current location and destination
    final distance = CommonFunctions.distance(
      currentLocation.latitude,
      currentLocation.longitude,
      destination.$1!,
      destination.$2!,
    );

    // Convert distance from km to meters
    final distanceInMeters = distance * 1000;

    debugPrint('Distance to destination: ${distanceInMeters.toStringAsFixed(2)} meters');

    // Check if user is within the arrival threshold
    return distanceInMeters <= _arrivalThreshold;
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Manually check arrival (useful for immediate checks)
  Future<void> checkArrivalNow() async {
    await _checkArrival();
  }

  /// Stop the automatic checking
  void stopChecking() {
    _stopTimer();
  }

  /// Restart the automatic checking
  void restartChecking() {
    _startTimer();
  }
}
