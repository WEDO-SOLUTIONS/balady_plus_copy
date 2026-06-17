import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/network_status.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/entities/search/models/search_region_bound.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/features/search/providers/search_region_bound_provider.dart';
import 'package:mapness/pages/routing/lib/route_point_extension.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'public_transport_visibility.g.dart';

/// Configuration constants for public transport visibility checks
class PublicTransportVisibilityConfig {
  static const Duration retryDelay = Duration(milliseconds: 1200);
  static const int maxRetryAttempts = 1;
}

enum PublicTransportVisibilityReason {
  noRoutes,
  notInRiyadh,
  noLocation,
  findRouteError,
  checkRiyadhRegionError,
  unknownError,
}

class PublicTransportVisibilityException implements Exception {
  final String message;
  final PublicTransportVisibilityReason reason;

  const PublicTransportVisibilityException({required this.message, required this.reason});
}

class PublicTransportVisibilityIsTooFarException implements Exception {
  const PublicTransportVisibilityIsTooFarException();
}

/// Result of public transport visibility check
class PublicTransportVisibilityResult {
  final bool isBothInRiyadh;
  final bool hasPublicTransportRoutes;
  final PublicTransportVisibilityReason? reason;

  const PublicTransportVisibilityResult({
    required this.isBothInRiyadh,
    required this.hasPublicTransportRoutes,
    this.reason,
  });

  bool get isPublicTransportAvailable => isBothInRiyadh && hasPublicTransportRoutes;
}

/// Provider that checks public transport route availability and regional constraints
@riverpod
class PublicTransportVisibility extends _$PublicTransportVisibility {
  @override
  Future<PublicTransportVisibilityResult> build({
    required RouteParamsPoint? startPoint,
    required RouteParamsPoint? finishPoint,
    RouteParamsPointList? intermediatePoints,
  }) async {
    try {
      final normalizedStartPoint = _normalizePoint(startPoint);
      final normalizedFinishPoint = _normalizePoint(finishPoint);

      final hasRoutes = await _checkPublicTransportRoutes(
        normalizedStartPoint,
        normalizedFinishPoint,
        intermediatePoints?.points.map((e) => e.value).nonNulls.toList(),
      );

      if (!hasRoutes) {
        return const PublicTransportVisibilityResult(
          isBothInRiyadh: true,
          hasPublicTransportRoutes: false,
          reason: PublicTransportVisibilityReason.noRoutes,
        );
      }

      final isBothInRiyadh = await _checkRiyadhRegion(normalizedStartPoint, normalizedFinishPoint);

      return PublicTransportVisibilityResult(
        isBothInRiyadh: isBothInRiyadh,
        hasPublicTransportRoutes: true,
        reason: isBothInRiyadh ? null : PublicTransportVisibilityReason.notInRiyadh,
      );
    } on NoInternetException {
      // Re-throw NoInternetException to be handled by UI
      rethrow;
    } on PublicTransportVisibilityException catch (e) {
      // Handle specific visibility exceptions
      return PublicTransportVisibilityResult(isBothInRiyadh: false, hasPublicTransportRoutes: false, reason: e.reason);
    } on PublicTransportVisibilityIsTooFarException {
      // Handle route distance exception
      return const PublicTransportVisibilityResult(
        isBothInRiyadh: false,
        hasPublicTransportRoutes: false,
        reason: PublicTransportVisibilityReason.findRouteError,
      );
    } catch (error) {
      // Re-check network status before returning unknown error
      final online = ref.read(networkStatusProvider);
      if (!online) {
        throw const NoInternetException();
      }

      // Return unknown error as result (not exception)
      return const PublicTransportVisibilityResult(
        isBothInRiyadh: false,
        hasPublicTransportRoutes: false,
        reason: PublicTransportVisibilityReason.unknownError,
      );
    }
  }

  /// Normalizes start point using current location if null
  RouteParamsPoint _normalizePoint(RouteParamsPoint? point) {
    if (point != null) {
      return point;
    }

    // Use ref.read to avoid rebuilding on every GPS update, which causes the
    // metro icon to flicker between normal/disabled on each location emission.
    final location = ref.read(locationProvider.select((v) => v == null ? null : (v.longitude, v.latitude)));
    if (location == null) {
      debugPrint('User location is null. Check [locationProvider] and permissions');
      throw const PublicTransportVisibilityException(
        message: 'User location is null',
        reason: PublicTransportVisibilityReason.noLocation,
      );
    }
    return RouteParamsPoint(longitude: location.$1, latitude: location.$2);
  }

  /// Checks if public transport routes are available with retry logic
  Future<bool> _checkPublicTransportRoutes(
    RouteParamsPoint startPoint,
    RouteParamsPoint finishPoint,
    List<RouteParamsPoint>? intermediatePoints,
  ) async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    final intermediateSearchPoints = intermediatePoints?.map((e) => e.routeSearchPointMessage).toList();
    try {
      // Initial route search
      final initialRoutes = await dgisController.findRoute(
        options: RouteSearchOptionsMessage.publicTransport,
        startPoint: startPoint.routeSearchPointMessage,
        finishPoint: finishPoint.routeSearchPointMessage,
        intermediatePoints: intermediateSearchPoints,
      );

      if (initialRoutes.routes.isEmpty) {
        throw const PublicTransportVisibilityIsTooFarException();
      }

      return initialRoutes.routes.isNotEmpty;
    } catch (e) {
      final online = ref.read(networkStatusProvider);
      if (!online) {
        throw const NoInternetException();
      }

      throw const PublicTransportVisibilityIsTooFarException();
    }
  }

  /// Checks if both points are within Riyadh region
  Future<bool> _checkRiyadhRegion(RouteParamsPoint startPoint, RouteParamsPoint finishPoint) async {
    try {
      final startRegion = await ref.read(
        searchRegionBoundProvider(longitude: startPoint.longitude, latitude: startPoint.latitude).future,
      );

      final finishRegion = await ref.read(
        searchRegionBoundProvider(longitude: finishPoint.longitude, latitude: finishPoint.latitude).future,
      );

      return startRegion.isRiyadh == true && finishRegion.isRiyadh == true;
    } catch (e) {
      throw PublicTransportVisibilityException(
        message: 'Error checking Riyadh region: ${e.toString()}',
        reason: PublicTransportVisibilityReason.checkRiyadhRegionError,
      );
    }
  }
}
