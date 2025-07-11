// ignore_for_file: unused_import

import 'package:dgis_map/library.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/entities/search/models/search_region_bound.dart';
import 'package:mapness/features/search/providers/search_region_bound_provider.dart';
import 'package:mapness/pages/routing/lib/route_point_extension.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'public_transport_visibility.g.dart';

@riverpod
class PublicTransportVisibility extends _$PublicTransportVisibility {
  @override
  Future<PublicTransportVisibilityResult> build({
    required RouteParamsPoint? startPoint,
    required RouteParamsPoint? finishPoint,
  }) async {
    // Check if public transport routes are available

    try {
      if (startPoint == null) {
        final location = ref.read(locationProvider);
        startPoint = RouteParamsPoint(
          longitude: location?.longitude ?? 0,
          latitude: location?.latitude ?? 0,
        );
      }
      if (finishPoint == null) {
        return const PublicTransportVisibilityResult(
          isBothInRiyadh: true,
          hasPublicTransportRoutes: false,
          reason: 'No start or finish point',
        );
      }
      final dgisController = await ref.read(dgisControllerProvider.future);
      final publicTransportRoutes = await dgisController.findRoute(
        options: RouteSearchOptionsMessage.publicTransport,
        startPoint: startPoint.routeSearchPointMessage,
        finishPoint: finishPoint.routeSearchPointMessage,
      );

      if (publicTransportRoutes.routes.isEmpty) {
        await Future.delayed(const Duration(milliseconds: 1200));
        final publicTransportRoutesRetry = await dgisController.findRoute(
          options: RouteSearchOptionsMessage.publicTransport,
          startPoint: startPoint.routeSearchPointMessage,
          finishPoint: finishPoint.routeSearchPointMessage,
        );
        if (publicTransportRoutesRetry.routes.isEmpty) {
          return const PublicTransportVisibilityResult(
            isBothInRiyadh: true,
            hasPublicTransportRoutes: false,
            reason: 'No public transport routes available for this route',
          );
        }
      }

      // Check if both points are in Riyadh region
      final startRegion = await ref.read(searchRegionBoundProvider(
        longitude: startPoint.longitude,
        latitude: startPoint.latitude,
      ).future);

      final finishRegion = await ref.read(searchRegionBoundProvider(
        longitude: finishPoint.longitude,
        latitude: finishPoint.latitude,
      ).future);

      final isBothInRiyadh = startRegion.isRiyadh == true && finishRegion.isRiyadh == true;

      return PublicTransportVisibilityResult(
        isBothInRiyadh: isBothInRiyadh,
        hasPublicTransportRoutes: true,
        reason: isBothInRiyadh ? null : 'Both points must be in Riyadh region',
      );
    } catch (e) {
      return PublicTransportVisibilityResult(
        isBothInRiyadh: true,
        hasPublicTransportRoutes: false,
        reason: 'Error checking public transport routes: ${e.toString()}',
      );
    }
  }
}

class PublicTransportVisibilityResult {
  final bool isBothInRiyadh;
  final bool hasPublicTransportRoutes;
  final String? reason;

  const PublicTransportVisibilityResult({
    required this.isBothInRiyadh,
    required this.hasPublicTransportRoutes,
    this.reason,
  });

  bool get isPublicTransportAvailable => isBothInRiyadh && hasPublicTransportRoutes;
}
