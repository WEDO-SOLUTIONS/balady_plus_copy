import 'dart:async';

import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/providers/favourite_markers.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/events.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/pages/routing/ui/routing_header_delegate.dart';
import 'package:mapness/pages/routing/ui/routing_history.dart';
import 'package:mapness/pages/routing/ui/routing_map_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';

class RoutingPointsPage extends StatelessWidget {
  const RoutingPointsPage({
    required this.collapseInitially,
    super.key,
  });

  /// open page with collapsed bottom sheet
  final bool collapseInitially;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => RoutingPointsSheet(
          biggestHeight: constraints.biggest.height,
          collapseInitially: collapseInitially,
        ),
      );
}

class RoutingPointsSheet extends ConsumerStatefulWidget {
  const RoutingPointsSheet({
    required this.biggestHeight,
    required this.collapseInitially,
    super.key,
  });
  final double biggestHeight;
  final bool collapseInitially;

  @override
  ConsumerState<RoutingPointsSheet> createState() => _RoutingPointsSheetState();
}

class _RoutingPointsSheetState extends ConsumerState<RoutingPointsSheet> {
  StreamSubscription<TapEvent>? _streamSubscription;

  List<RoutePoint> points = [
    RoutePointMyLocation(),
    RoutePointDirectoryObject(null),
  ];

  @override
  void initState() {
    super.initState();
    _setupTapListener();
  }

  @override
  void deactivate() {
    _streamSubscription?.cancel();
    super.deactivate();
  }

  Future<void> _setupTapListener() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    _streamSubscription =
        dgisController.objectTapEvents.listen(_objectTapListener);
  }

  void _objectTapListener(TapEvent event) {
    if (event is ObjectTapEvent) {
      ref.read(urbiMetricsProvider.notifier).logEvent(
        'POI/Object => Tap',
        {'objectId': event.dgisObjectId.objectId},
      );
      if (context.mounted) {
        PoiMapRoute.open(
            ref.read(goRouterProvider), event.dgisObjectId.objectId);
      }
    } else if (event is RoadEventTapEvent) {
      ref.read(urbiMetricsProvider.notifier).logEvent(
        'POI/Road event => Tap',
        {'objectId': event.id.objectId, 'title': event.title},
      );
      EventsRoute.open(context, event);
    }
  }

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    //TODO(Someone): Fix layers lifecicle
    final esri = MapObjectManagerSettings.esri();
    final mappness = MapObjectManagerSettings.mappness();

    ref
      ..watch(layersControlsProvider)
      ..watch(favouriteMarkersProvider.select((value) => null))

      /// keep iwish markers alive when page is opened  (DO NOT DELETE UNTIL REFACOR OF LAYER CONTROLS!)
      ..watch(mapObjectManagerProvider(named: esri.name, layerId: esri.layerId)
          .notifier)
      ..watch(mapObjectManagerProvider(
              named: mappness.name, layerId: mappness.layerId)
          .notifier);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: [
          const RoutingMapControls(
            bottomExtent: 136,
          ),
          DgisBottomSheet(
            showBarrier: false,
            availableExpansions: const {
              Expansion.collapsed,
              Expansion.expanded,
              Expansion.middle,
            },
            initialExpansion: widget.collapseInitially
                ? Expansion.collapsed
                : Expansion.middle,
            middleHeight: 0.7 * widget.biggestHeight,
            collapsedHeight: 136,
            scrollableBody: (context, scrollController) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
                ),
              ),
              child: Material(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
                ),
                color: NonThemeColor.color11,
                child: CustomScrollView(
                  controller: scrollController,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    SliverPersistentHeader(
                      delegate: RoutingHeaderDelegate(
                        points: points,
                        updatePoints: _updatePoints,
                      ),
                      pinned: true,
                    ),
                    SliverToBoxAdapter(
                      child: RoutingHistory(
                        updatePoint: (point) {
                          setState(() {
                            if (points[0].isNotEmpty) {
                              points[1] = point;
                            } else {
                              points[0] = point;
                            }
                          });
                          if (points.every((element) => element.isNotEmpty)) {
                            RoutingRoutesRoute(
                              startLatitude: points[0].latitude,
                              startLongitude: points[0].longitude,
                              startObjectId: points[0].objectId,
                              startEntranceId: points[0].entranceId,
                              startLevelId: points[0].levelId,
                              startLabel: points[0].title(context.l10n) ?? '',
                              finishLatitude: points[1].latitude,
                              finishLongitude: points[1].longitude,
                              finishObjectId: points[1].objectId,
                              finishEntranceId: points[1].entranceId,
                              finishLevelId: points[1].levelId,
                              finishLabel: points[1].title(context.l10n) ?? '',
                            ).go(context);
                          }
                        },
                        searchByQuery: (query) {
                          ref.read(urbiMetricsProvider.notifier).logEvent(
                            'Routes/Search/Query => Update',
                            {'query': query},
                          );
                          final index = points[0].isNotEmpty ? 1 : 0;
                          RoutingSearchRoute(
                            placeholder: index == 0
                                ? context.l10n.from
                                : context.l10n.to,
                            showMyLocation: index == 0 &&
                                points[index] is! RoutePointMyLocation,
                            initialQuery: query,
                          ).push(context).then(
                            (value) {
                              if (value != null && value is RoutePoint) {
                                points[index] = value;
                                _updatePoints(points);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updatePoints(List<RoutePoint> newPoitns) {
    setState(() {
      points = newPoitns;
    });
    if (points.every((element) => element.isNotEmpty)) {
      RoutingRoutesRoute(
        startLatitude: points[0].latitude,
        startLongitude: points[0].longitude,
        startObjectId: points[0].objectId,
        startEntranceId: points[0].entranceId,
        startLevelId: points[0].levelId,
        startLabel: points[0].title(context.l10n) ?? '',
        finishLatitude: points[1].latitude,
        finishLongitude: points[1].longitude,
        finishObjectId: points[1].objectId,
        finishEntranceId: points[1].entranceId,
        finishLevelId: points[1].levelId,
        finishLabel: points[1].title(context.l10n) ?? '',
      ).go(context);
    }
  }
}
