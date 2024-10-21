import 'package:auto_route/auto_route.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
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
                context.router.push(
                  RoutingRoutesRoute(
                    points: [
                      null,
                      RouteParamsPoint(
                        latitude: latitude,
                        longitude: longitude,
                        objectId: data.id?.objectId,
                        entranceId: data.id?.entranceId
                      ),
                    ],
                    labels: [context.l10n.myLocation, label ?? ''],
                  ),
                );
              },
            ),
    );
  }
}
