import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/export/models/mapness_route_point.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

export 'package:mapness/export/models/mapness_route_point.dart';

class MapnessFunctions {
  static Future<void> openRoutesScreen({
    required BuildContext context,
    required MapnessRoutePoint finishPoint,
    MapnessRoutePoint? startPoint,
  }) async {
    final appLocalizations = context.read<AppLocalizations>();

    await context.router.push(
      RoutingRoutesRoute(
        points: [
          if (startPoint?.latitude != null && startPoint?.longitude != null) RouteParamsPoint(
            latitude: startPoint!.latitude,
            longitude: startPoint.longitude,
          ),
          RouteParamsPoint(
            latitude: finishPoint.latitude,
            longitude: finishPoint.longitude,
          ),
        ],
        labels: [
          startPoint?.label ?? appLocalizations.myLocation,
          finishPoint.label
        ],
      ),
    );
  }
}
