import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/providers/favourite_markers.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/pages/routing/ui/routing_header_delegate.dart';
import 'package:mapness/pages/routing/ui/routing_history.dart';
import 'package:mapness/pages/routing/ui/routing_map_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';

@RoutePage()
class RoutingPointsPage extends StatelessWidget {
  const RoutingPointsPage({super.key});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => RoutingPointsSheet(
          biggestHeight: constraints.biggest.height,
        ),
      );
}

class RoutingPointsSheet extends ConsumerStatefulWidget {

  const RoutingPointsSheet({
    required this.biggestHeight,
    super.key,
  });

  final double biggestHeight;

  @override
  ConsumerState<RoutingPointsSheet> createState() => _RoutingPointsSheetState();
}

class _RoutingPointsSheetState extends ConsumerState<RoutingPointsSheet> {
  static const controlsBottomExtent = 136.0;
  static const _bottomSheetAspectRatios = [.15, .7, .931];

  List<RoutePoint> points = [
    RoutePointMyLocation(),
    RoutePointDirectoryObject(null),
  ];

  /// Subscribes to object tap events on the map
  StreamSubscription<TapEvent>? _objectTapStreamSubscription;

  /// Bottom sheet controller
  late final StatefulBottomSheetController<ThreeStateBottomSheet> bottomSheetController;

  @override
  void initState() {
    bottomSheetController = StatefulBottomSheetController(
      behavior: AspectRatioSnappingBehavior(aspectRatios: _bottomSheetAspectRatios),
      stateMapper: const ThreeStateMapper(),
      initialState: ThreeStateBottomSheet.open,
    );
    _setupTapListener();
    super.initState();
  }

  @override
  void deactivate() {
    _objectTapStreamSubscription?.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    //TODO(Someone): Fix layers lifecicle
    final esri = MapObjectManagerSettings.esri();
    final mappness = MapObjectManagerSettings.mappness();

    ref
      ..watch(layersControlsProvider)
      ..watch(favouriteMarkersProvider.select((value) => null))

      /// keep iwish markers alive when page is opened  (DO NOT DELETE UNTIL REFACOR OF LAYER CONTROLS!)
      ..watch(mapObjectManagerProvider(named: esri.name, layerId: esri.layerId).notifier)
      ..watch(mapObjectManagerProvider(named: mappness.name, layerId: mappness.layerId).notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Stack(
        children: [
          const RoutingMapControls(
            bottomExtent: controlsBottomExtent,
          ),
          StatefulBottomSheet<ThreeStateBottomSheet>(
            animateOpening: false,
            sliverBeforeContent: SliverPersistentHeader(
              delegate: RoutingHeaderDelegate(
                points: points,
                updatePoints: _updatePoints,
              ),
              pinned: true,
              floating: true,
            ),
            content: [
              Column(
                children: [
                  RoutingHistory(
                    updatePoint: _updatePoint,
                    searchByQuery: _searchQuery,
                  ),
                ],
              ),
            ],
            scrollController: bottomSheetController,
          ),
        ],
      ),
    );
  }

  void _updatePoints(List<RoutePoint> newPoints) {
    setState(() => points = newPoints);
    _showRoute();
  }

  void _updatePoint(RoutePoint point) {
    setState(() {
      if (points[0].isNotEmpty) {
        points[1] = point;
      } else {
        points[0] = point;
      }
    });
    _showRoute();
  }

  void _showRoute() {
    if (points.every((element) => element.isNotEmpty)) {
      final start = points[0];
      final finish = points[1];

      context.router.push(
        RoutingRoutesRoute(points: [
          RouteParamsPointWithLabel(
            value: start.latitude != null && start.longitude != null
                ? RouteParamsPoint(
                    latitude: start.latitude!,
                    longitude: start.longitude!,
                    objectId: start.objectId,
                    entranceId: start.entranceId,
                    levelId: start.levelId,
                  )
                : null,
            label: start.title(context.l10n) ?? '',
          ),
          RouteParamsPointWithLabel(
            value: finish.latitude != null && finish.longitude != null
                ? RouteParamsPoint(
                    latitude: finish.latitude!,
                    longitude: finish.longitude!,
                    objectId: finish.objectId,
                    entranceId: finish.entranceId,
                    levelId: finish.levelId,
                  )
                : null,
            label: finish.title(context.l10n) ?? '',
          ),
        ]),
      );

      points = [
        RoutePointMyLocation(),
        RoutePointDirectoryObject(null),
      ];
    }
  }

  Future<void> _searchQuery(String query) async {
    final index = points[0].isNotEmpty ? 1 : 0;
    final value = await context.router.push(RoutingSearchSheetRoute(
      placeholder: index == 0 ? context.l10n.from : context.l10n.to,
      showMyLocation: index == 0 && points[index] is! RoutePointMyLocation,
      initialQuery: query,
    ));

    if (value != null && value is RoutePoint) {
      points[index] = value;
      _updatePoints(points);
    }
  }

  Future<void> _setupTapListener() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    _objectTapStreamSubscription = dgisController.objectTapEvents.listen(
      _tapListener,
    );
  }

  void _tapListener(event) {
    if (event is ObjectTapEvent) {
      final state = bottomSheetController.state;
      switch (state) {
        case ThreeStateBottomSheet.open:
          break;
        case ThreeStateBottomSheet.hidden:
        case ThreeStateBottomSheet.expanded:
          bottomSheetController.setState(ThreeStateBottomSheet.open);
          break;
      }
    }
  }
}
