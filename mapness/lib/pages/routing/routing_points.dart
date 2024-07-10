import 'dart:async';

import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/providers/favourite_markers.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/pages/routing/ui/routing_header_delegate.dart';
import 'package:mapness/pages/routing/ui/routing_history.dart';
import 'package:mapness/pages/routing/ui/routing_map_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/router_extension.dart';
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
  List<RoutePoint> points = [
    RoutePointMyLocation(),
    RoutePointDirectoryObject(null),
  ];
  StreamSubscription<TapEvent>? _streamSubscription;
  late final DgisBottomSheetController dgisBottomSheetController;

  @override
  void initState() {
    dgisBottomSheetController = DgisBottomSheetController();
    _setupTapListener();
    super.initState();
  }

  @override
  void deactivate() {
    _streamSubscription?.cancel();
    super.deactivate();
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
      ..watch(mapObjectManagerProvider(named: esri.name, layerId: esri.layerId).notifier)
      ..watch(mapObjectManagerProvider(named: mappness.name, layerId: mappness.layerId).notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            const RoutingMapControls(
              bottomExtent: 136,
            ),
            DgisBottomSheet(
              controller: dgisBottomSheetController,
              showBarrier: false,
              availableExpansions: const {
                Expansion.collapsed,
                Expansion.expanded,
                Expansion.middle,
              },
              initialExpansion: widget.collapseInitially ? Expansion.collapsed : Expansion.middle,
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
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                          updatePoint: _updatePoint,
                          searchByQuery: _searchQuery,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updatePoints(List<RoutePoint> newPoitns) {
    setState(() {
      points = newPoitns;
    });
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
      RoutingRoutesRoute(
        startLatitude: start.latitude,
        startLongitude: start.longitude,
        startObjectId: start.objectId,
        startEntranceId: start.entranceId,
        startLevelId: start.levelId,
        startLabel: start.title(context.l10n) ?? '',
        finishLatitude: finish.latitude,
        finishLongitude: finish.longitude,
        finishObjectId: finish.objectId,
        finishEntranceId: finish.entranceId,
        finishLevelId: finish.levelId,
        finishLabel: finish.title(context.l10n) ?? '',
      ).push(context);
    }
  }

  Future<void> _searchQuery(String query) async {
    final index = points[0].isNotEmpty ? 1 : 0;
    final route = RoutingSearchRoute(
      placeholder: index == 0 ? context.l10n.from : context.l10n.to,
      showMyLocation: index == 0 && points[index] is! RoutePointMyLocation,
      initialQuery: query,
    );
    final value = await route.push(context);

    if (value != null && value is RoutePoint) {
      points[index] = value;
      _updatePoints(points);
    }
  }

  Future<void> _setupTapListener() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    _streamSubscription = dgisController.objectTapEvents.listen(
      _tapListener,
    );
  }

  void _tapListener(event) {
    final goRouter = ref.read(goRouterProvider);

    if (event is ObjectTapEvent) {
      final expansion = dgisBottomSheetController.currentExpansion!;
      switch (expansion) {
        case Expansion.expanded:
        case Expansion.middle:
          dgisBottomSheetController.animateTo(Expansion.collapsed);
          break;
        case Expansion.hidden:
        case Expansion.collapsed:
        case Expansion.fullHidePhoto:
          break;
      }
    if (goRouter.isCurrentRoute(RoutingMapRoute.path)) {
      return;
    }
    }
  }

}
