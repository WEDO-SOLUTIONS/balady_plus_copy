import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routing.dart' hide $appRoutes;
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
    final goRouter = context.read<GoRouter>();
    final appLocalizations = context.read<AppLocalizations>();

    final route = RoutingRoutesRoute(
      startLatitude: startPoint?.latitude,
      startLongitude: startPoint?.longitude,
      startLabel: startPoint?.label ?? appLocalizations.myLocation,
      startObjectId: null,
      startEntranceId: null,
      startLevelId: null,
      finishLatitude: finishPoint.latitude,
      finishLongitude: finishPoint.longitude,
      finishLabel: finishPoint.label,
      finishObjectId: null,
      finishEntranceId: null,
      finishLevelId: null,
    );

    // final mapnessRoutes = $appRoutes
    //     .whereType<GoRoute>()
    //     .map((e) => RegExp(r'/(\w|\d|-|_)*').firstMatch(e.path)?.group(0))
    //     .nonNulls
    //     .toSet()
    //     .toList();
    // print(mapnessRoutes);

    Navigator.of(context).popUntil(
      (path) => path.settings.name?.startsWith('/') ?? false,
    );
    goRouter.go(route.location);
  }
}
