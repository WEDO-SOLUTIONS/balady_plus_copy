import 'package:dgis_map/library.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/entities/search/models/search_region_bound.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/features/search/providers/search_region_bound_provider.dart';
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
      final publicTransportRoutes = await ref.watch(publicTransportRoutesProvider(
        startPoint: startPoint,
        finishPoint: finishPoint,
        navType: RouteSearchOptionsMessage.publicTransport,
      ).future);

      if (publicTransportRoutes.isEmpty) {
        return const PublicTransportVisibilityResult(
          isBothInRiyadh: true,
          hasPublicTransportRoutes: false,
          reason: 'No public transport routes available for this route',
        );
      }

      // Check if both points are in Riyadh region
      final startRegion = await ref.read(searchRegionBoundProvider(
        longitude: startPoint?.longitude ?? 0,
        latitude: startPoint?.latitude ?? 0,
      ).future);

      final finishRegion = await ref.read(searchRegionBoundProvider(
        longitude: finishPoint?.longitude ?? 0,
        latitude: finishPoint?.latitude ?? 0,
      ).future);

      final isBothInRiyadh = startRegion.isRiyadh == true && finishRegion.isRiyadh == true;

      return PublicTransportVisibilityResult(
        isBothInRiyadh: isBothInRiyadh,
        hasPublicTransportRoutes: publicTransportRoutes.isNotEmpty,
        reason: publicTransportRoutes.isNotEmpty ? null : 'Both points must be in Riyadh region',
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
