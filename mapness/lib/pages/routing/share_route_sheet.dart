import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/entities/coordinates.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/lib/share_util.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/short_link_repository.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class ShareRoutePage extends HookConsumerWidget {
  final List<RouteParamsPointWithLabel> points;
  final RouteSearchOptionsMessage navType;
  final int activeRouteIndex;

  const ShareRoutePage({required this.points, required this.navType, required this.activeRouteIndex, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useToggleSheetController(
      onClose: (controller) {
        context.router.pop();
      },
    );

    final destinationObjectId = points.last.value?.objectId;

    return ToggleSheet(
      scrollController: scrollController,
      backgroundColor: context.colors.backgroundSurface4,
      safeAreaColor: context.colors.backgroundSurface4,
      dragger: SheetDragger(backgroundColor: context.colors.backgroundSurface4),
      outside: GestureDetector(onTap: context.router.pop),
      content: [
        Padding(
          padding: const EdgeInsets.all(Spacing.$4x),
          child: ContentWrapper(
            color: context.colors.backgroundSurface1,
            children: [
              if (destinationObjectId != null)
                ContentRow(
                  isDividerEnabled: true,
                  leading: Icon(SystemIcons.share, color: context.colors.foregroundSoft),
                  text: ContentRowTextOptions(title: context.l10n.shareDestination),
                  onTap: () async {
                    await _shareDestination(context, ref, destinationObjectId);
                    context.router.pop();
                  },
                ),
              ContentRow(
                leading: Icon(GeneralIcons.routeStroke, color: context.colors.foregroundSoft),
                text: ContentRowTextOptions(title: context.l10n.shareThisRoute),
                onTap: () async {
                  await _shareRoute(context, ref);
                  context.router.pop();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _shareDestination(BuildContext context, WidgetRef ref, int destinationObjectId) async {
    final lastPoint = points.last;
    final isMyLocation = isLocation(context.l10n, lastPoint);
    final location = isMyLocation ? await ref.read(getLocationSyncProvider().future) : null;

    if (isMyLocation && location == null) {
      // unable to get location for point that needs it
      return;
    }

    final end = _mapPoint(context.l10n, location, points.last);
    if (end == null) {
      return;
    }

    final lat = lastPoint.value?.latitude;
    final lon = lastPoint.value?.longitude;
    final coordinates = lat != null && lon != null ? Coordinates(latitude: lat, longitude: lon) : null;

    ShareUtil.sharePOI(
      context: context,
      objectId: destinationObjectId.toString(),
      markerCoords: coordinates,
    );
  }

  bool isLocation(AppLocalizations l10n, RouteParamsPointWithLabel p) => p.label == l10n.myLocation;

  ShortLinkPayloadTripRoutePoint? _mapPoint(AppLocalizations l10n, Position? location, RouteParamsPointWithLabel p) {
    if (isLocation(l10n, p)) {
      return ShortLinkPayloadTripRoutePoint(
        lat: location!.latitude,
        lon: location.longitude,
        poiId: p.value?.objectId?.toString(),
        label: p.label,
      );
    }

    final point = p.value;
    if (point == null) {
      return null;
    }

    return ShortLinkPayloadTripRoutePoint(
      lat: point.latitude,
      lon: point.longitude,
      poiId: p.value?.objectId?.toString(),
      label: p.label,
    );
  }

  Future<void> _shareRoute(BuildContext context, WidgetRef ref) async {
    final hasMyLocation = points.any((e) => isLocation(context.l10n, e));
    final Position? location;
    if (hasMyLocation) {
      location = await ref.read(getLocationSyncProvider().future);
    } else {
      location = null;
    }

    if (hasMyLocation && location == null) {
      // unable to get location for point that needs it
      return;
    }

    ShortLinkPayloadTripRoutePoint? mapPoint(RouteParamsPointWithLabel p) => _mapPoint(context.l10n, location, p);

    final start = mapPoint(points.first);
    final end = mapPoint(points.last);
    if (start == null || end == null) {
      return;
    }

    final intermediatePoints = points.getIntermediatePointsWithLabels();
    final midPoints = intermediatePoints?.points.map(mapPoint).nonNulls.toList();

    ShareUtil.shareTrip(
      context: context,
      data: ShortLinkPayloadTrip(
        route: ShortLinkPayloadTripRoute(
          startPoint: start,
          endPoint: end,
          midPoints: midPoints,
          type: ShortLinkTransportType.message(navType),
          routeIndex: activeRouteIndex,
        ),
      ),
    );
  }
}
