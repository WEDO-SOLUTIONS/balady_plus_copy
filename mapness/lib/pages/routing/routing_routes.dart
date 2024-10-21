import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/providers/favourite_markers.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/routing/providers/routes_helper.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/routing/ui/routing_change_path_sheet.dart';
import 'package:mapness/pages/routing/ui/routing_info.dart';
import 'package:mapness/pages/routing/ui/routing_map_controls.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/widgets/routing/ui_kit/ab_point/ab_points.dart';
import 'package:urbi_utils/urbi_utils.dart';

@RoutePage()
class RoutingRoutesPage extends ConsumerStatefulWidget {
  final List<RouteParamsPoint?> points;
  final List<String> labels;

  const RoutingRoutesPage({
    required this.points,
    required this.labels,
    super.key,
  });

  @override
  ConsumerState<RoutingRoutesPage> createState() => _RoutingRoutesPageState();
}

class _RoutingRoutesPageState extends ConsumerState<RoutingRoutesPage> {
  late List<RouteParamsPoint?> points;
  late List<String> labels;

  @override
  void initState() {
    super.initState();
    points = widget.points;
    labels = widget.labels;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final locationPermission = ref.read(locationProvider.notifier);

    /// if route from user location make sure he has location permission
    if (widget.points.any((element) => element == null)) {
      locationPermission.checkLocationPermission(
        routeOnClose: RoutingRoutesRoute.name,
      );
    }
  }

  @override
  void deactivate() {
    ref.read(dgisControllerProvider).value?.hideRoutes();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    //TODO(Someone): Fix layers lifecicle
    final esri = MapObjectManagerSettings.esri();
    final mappness = MapObjectManagerSettings.mappness();

    ref
      ..watch(layersControlsProvider)
      ..watch(routesHelperProvider)
      ..watch(locationProvider.select((_) => null))
      ..watch(favouriteMarkersProvider.select((value) => null))

      /// keep iwish markers alive when page is opened  (DO NOT DELETE UNTIL REFACOR OF LAYER CONTROLS!)
      ..watch(mapObjectManagerProvider(named: esri.name, layerId: esri.layerId).notifier)
      ..watch(mapObjectManagerProvider(named: mappness.name, layerId: mappness.layerId).notifier);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        RoutingMapControls(
          bottomExtent: MediaQuery.of(context).size.height * 0.3,
        ),
        BottomSheet(
          backgroundColor: context.color.surfaceBasePrimary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          onClosing: () => {},
          builder: (context) => SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: Spacing.$4x,
                    right: Spacing.$4x,
                    top: Spacing.$4x,
                  ),
                  child: Row(
                    children: <Widget>[
                      AppButton(
                        primaryIcon: SystemIcons.arrowLeft,
                        buttonColorScheme: ButtonColorScheme.tertiary,
                        onTap: _onClose,
                      ),
                      AppButton(
                        primaryIcon: TransportIcons.verticalChange,
                        buttonColorScheme: ButtonColorScheme.tertiary,
                        onTap: _onSwipeRoutes,
                      ),
                      Expanded(
                        child: ABPoints(
                          locations: labels,
                          onTap: _changeRoute,
                        ),
                      ),
                    ].insertBetween(Spacing.$3x.widthBox).toList(),
                  ),
                ),
                RoutingInfo(points: points),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onSwipeRoutes() {
    Metrics.logEventAdvanced(
      MetricsConstants.routesKeys.routeSelectionReverseRouteDirectionIcon,
      group: MetricsConstants.routesTag,
      action: MetricAction.tap.toString(),
    );

    setState(() {
      points = points.reversed.toList();
      labels = labels.reversed.toList();
    });
  }

  /// On tap of the ABPoints widget, show the bottom sheet to change the route
  void _changeRoute() {
    final myLocation = ref.watch(locationProvider);
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(Spacing.$4x),
      ),
    );
    showModalBottomSheet(
      backgroundColor: context.color.surfaceBasePrimary,
      shape: shape,
      context: context,
      builder: (context) => ChangePathSheet(
        onConfirm: _onConfirm,
        myLocation:
            myLocation == null ? null : GeoPointMessage(latitude: myLocation.latitude, longitude: myLocation.longitude),
        onTap: () {
          // Don't want to pass ref to the sheet, so we have to clear the search results here
          ref.read(searchProvider(SearchScopeEnum.routes.value).notifier).clear();
        },
        // We need to pass the points and labels as copy (List.of) to manipulate the data and
        // change original data only when user confirms
        points: List.of(points),
        labels: List.of(labels),

        onClose: () => context.router.maybePop(),
        // We have to pass external context to the sheet to be able to get the colors, text styles, etc.
        externalContext: context,
      ),
    );
  }

  /// Confirm the reordering of the points. Also close the bottom sheet
  void _onConfirm(
    List<RouteParamsPoint?> points,
    List<String> labels,
  ) {
    setState(() {
      this.points = points;
      this.labels = labels;
    });
    context.router.maybePop();
  }

  void _onClose() {
    final mapSetting = MapObjectManagerSettings.search();
    ref
        .read(
          mapObjectManagerProvider(
            named: mapSetting.name,
            layerId: mapSetting.layerId,
          ).notifier,
        )
        .setMapObjectManagerIsVisible(isVisible: true);

    Metrics.logEventAdvanced(
      MetricsConstants.routesKeys.routeSelectionBack,
      group: MetricsConstants.routesTag,
      action: MetricAction.tap.toString(),
    );

    context.back();
  }
}
