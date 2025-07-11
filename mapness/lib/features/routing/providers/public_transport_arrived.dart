import 'dart:async';

import 'package:dgis_map/library.dart';
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
    required BriefPublicTransportModel route,
    required String? destination,
  }) async {
    // Start the timer to check arrival every 30 seconds
    _startTimer();

    // Return false initially (not arrived yet)
    return false;
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
    final destinationCoords = _getFinalDestinationCoordinates();
    if (destinationCoords == null) {
      // Because if destination is null, this is my location
      return true;
    }

    // Calculate distance between current location and destination
    final distance = CommonFunctions.distance(
      currentLocation.latitude,
      currentLocation.longitude,
      destinationCoords.latitude,
      destinationCoords.longitude,
    );

    // Convert distance from km to meters
    final distanceInMeters = distance * 1000;

    debugPrint('Distance to destination: ${distanceInMeters.toStringAsFixed(2)} meters');

    // Check if user is within the arrival threshold
    return distanceInMeters <= _arrivalThreshold;
  }

  /// Extract the final destination coordinates from the route
  GeoPointMessage? _getFinalDestinationCoordinates() {
    try {
      final transfers = route.publicTransportTransferRouteLongEntry;
      if (transfers.isEmpty) {
        return null;
      }

      // Get the last transfer which should contain the final destination
      final lastTransfer = transfers.last;
      final lastTransferValue = lastTransfer.value;

      // If the last transfer has route parts, get the final stop coordinates
      if (lastTransferValue.routeParts.isNotEmpty) {
        final lastRoutePart = lastTransferValue.routeParts.last;
        if (lastRoutePart.intermediateStops.isNotEmpty) {
          final finalStop = lastRoutePart.intermediateStops.last;
          return finalStop.coordinates;
        }
      }

      // If no route parts or intermediate stops, try to get coordinates from the finish point
      // This might require additional logic depending on how the route data is structured
      // For now, we'll return null and rely on the destination parameter
      return null;
    } catch (e) {
      debugPrint('Error extracting final destination coordinates: $e');
      return null;
    }
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
