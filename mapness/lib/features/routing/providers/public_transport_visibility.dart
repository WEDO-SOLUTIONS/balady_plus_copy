import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
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

  const PublicTransportVisibilityException({
    required this.message,
    required this.reason,
  });
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
  }) async {
    final online = ref.watch(networkStatusProvider);
    try {
      if (!online) {
        throw const NoInternetException();
      }

      final normalizedStartPoint = _normalizePoint(startPoint);
      final normalizedFinishPoint = _normalizePoint(finishPoint);

      final hasRoutes = await _checkPublicTransportRoutes(
        normalizedStartPoint,
        normalizedFinishPoint,
      );

      if (!hasRoutes) {
        return const PublicTransportVisibilityResult(
          isBothInRiyadh: true,
          hasPublicTransportRoutes: false,
          reason: PublicTransportVisibilityReason.noRoutes,
        );
      }

      final isBothInRiyadh = await _checkRiyadhRegion(
        normalizedStartPoint,
        normalizedFinishPoint,
      );

      return PublicTransportVisibilityResult(
        isBothInRiyadh: isBothInRiyadh,
        hasPublicTransportRoutes: true,
        reason: isBothInRiyadh ? null : PublicTransportVisibilityReason.notInRiyadh,
      );
    } on PublicTransportVisibilityException catch (e) {
      return PublicTransportVisibilityResult(
        isBothInRiyadh: false,
        hasPublicTransportRoutes: false,
        reason: e.reason,
      );
    } on PublicTransportVisibilityIsTooFarException catch (_) {
      return const PublicTransportVisibilityResult(
        isBothInRiyadh: false,
        hasPublicTransportRoutes: false,
        reason: PublicTransportVisibilityReason.findRouteError,
      );
    } catch (error) {
      if (!online) {
        throw const NoInternetException();
      }

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

    final location = ref.watch(locationProvider);
    if (location == null) {
      debugPrint('User location is null. Check [locationProvider] and permissions');
      throw const PublicTransportVisibilityException(
        message: 'User location is null',
        reason: PublicTransportVisibilityReason.noLocation,
      );
    }
    return RouteParamsPoint(
      longitude: location.longitude,
      latitude: location.latitude,
    );
  }

  /// Checks if public transport routes are available with retry logic
  Future<bool> _checkPublicTransportRoutes(
    RouteParamsPoint startPoint,
    RouteParamsPoint finishPoint,
  ) async {
    final online = ref.watch(networkStatusProvider);
    final dgisController = await ref.read(dgisControllerProvider.future);
    try {
      // Initial route search
      final initialRoutes = await dgisController.findRoute(
        options: RouteSearchOptionsMessage.publicTransport,
        startPoint: startPoint.routeSearchPointMessage,
        finishPoint: finishPoint.routeSearchPointMessage,
      );

      if (initialRoutes.routes.isEmpty) {
        throw const PublicTransportVisibilityIsTooFarException();
      }

      return initialRoutes.routes.isNotEmpty;
    } catch (e) {
      if (!online) {
        throw const NoInternetException();
      }

      throw const PublicTransportVisibilityIsTooFarException();
    }
  }

  /// Checks if both points are within Riyadh region
  Future<bool> _checkRiyadhRegion(
    RouteParamsPoint startPoint,
    RouteParamsPoint finishPoint,
  ) async {
    try {
      final startRegion = await ref.read(searchRegionBoundProvider(
        longitude: startPoint.longitude,
        latitude: startPoint.latitude,
      ).future);

      final finishRegion = await ref.read(searchRegionBoundProvider(
        longitude: finishPoint.longitude,
        latitude: finishPoint.latitude,
      ).future);

      return startRegion.isRiyadh == true && finishRegion.isRiyadh == true;
    } catch (e) {
      throw PublicTransportVisibilityException(
        message: 'Error checking Riyadh region: ${e.toString()}',
        reason: PublicTransportVisibilityReason.checkRiyadhRegionError,
      );
    }
  }
}
