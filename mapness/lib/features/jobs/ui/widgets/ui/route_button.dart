import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/features/jobs/providers/job_distance_provider.dart';
import 'package:mapness/features/routing/ui/brief_route_widgets.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class RouteButton extends ConsumerWidget {
  final double latitude;
  final double longitude;
  final String? label;

  const RouteButton({
    required this.latitude,
    required this.longitude,
    this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobDistance = ref.watch(jobDistanceProvider(latitude, longitude));

    if (jobDistance.hasValue && jobDistance.valueOrNull == null) {
      return const SizedBox.shrink();
    }

    return jobDistance.maybeWhen(
      orElse: () => const SizedBox.shrink(),
      data: (data) => data?.point == null || data?.id == null
          ? const SizedBox.shrink()
          : BriefRouteButton(
              finishPoint: RouteSearchPoint(coordinates: data!.point!, dgisObjectId: data.id!),
              routeType: RouteSearchOptionsMessage.car,
              onTap: () {
                RoutingRoutesRoute(
                  finishLabel: label ?? '',
                  finishLatitude: latitude,
                  finishLongitude: longitude,
                  finishObjectId: data.id?.objectId,
                  finishEntranceId: data.id?.entranceId,
                  finishLevelId: null,
                  startLabel: context.l10n.myLocation,
                  startLatitude: null,
                  startLongitude: null,
                  startObjectId: null,
                  startEntranceId: null,
                  startLevelId: null,
                ).push(context);
              },
            ),
    );
  }
}
