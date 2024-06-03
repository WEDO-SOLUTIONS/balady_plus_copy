import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/favourites/providers/favourite_markers.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/pages/routing/lib/route_point_extension.dart';
import 'package:mapness/pages/routing/ui/routing_info.dart';
import 'package:mapness/pages/routing/ui/routing_map_controls.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/routing/current_route_provider.dart';
import 'package:mapness/widgets/routing/ui_kit/ab_point/ab_points.dart';
import 'package:urbi_utils/urbi_utils.dart';

class RoutingRoutesPage extends ConsumerStatefulWidget {
  const RoutingRoutesPage({
    required this.points,
    required this.labels,
    super.key,
  });

  final List<RouteParamsPoint?> points;
  final List<String> labels;

  @override
  ConsumerState<RoutingRoutesPage> createState() => _RoutingRoutesPageState();
}

class _RoutingRoutesPageState extends ConsumerState<RoutingRoutesPage> {
  late List<RouteParamsPoint?> points;
  late List<String> labels;
  late List<RouteSearchPointMessage?> searchPoints;

  @override
  void initState() {
    super.initState();
    points = widget.points;
    labels = widget.labels;
    searchPoints = widget.points
        .map(
          (e) => e?.routeSearchPointMessage,
        )
        .toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final locationPermission = ref.read(locationProvider.notifier);

    /// if route from user location make sure he has location permission
    if (widget.points.any((element) => element == null)) {
      locationPermission.checkLocationPermission(
        routeOnClose: const RoutingRoute().location,
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
                    left: Spacing.horizontalPaddingInsideWrapper,
                    right: Spacing.horizontalPaddingInsideWrapper,
                    top: Spacing.verticalPaddingInsideWrapper,
                  ),
                  child: Row(
                    children: <Widget>[
                      AppButton(
                        primaryIcon: switch (Directionality.of(context)) {
                          TextDirection.ltr => SystemIcons.arrowLeft,
                          TextDirection.rtl => SystemIcons.arrowRight
                        },
                        buttonColorScheme: ButtonColorScheme.tertiary,
                        onTap: _onClose,
                      ),
                      AppButton(
                        primaryIcon: TransportIcons.verticalChange,
                        buttonColorScheme: ButtonColorScheme.tertiary,
                        onTap: _onSwipeRoutes,
                      ),
                      Expanded(child: ABPoints(locations: labels)),
                    ]
                        .insertBetween(
                          Spacing.horizontalGapBetweenCellContent.widthBox,
                        )
                        .toList(),
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
      searchPoints = searchPoints.reversed.toList();
    });
  }

  void _onClose() {
    Metrics.logEventAdvanced(
      MetricsConstants.routesKeys.routeSelectionBack,
      group: MetricsConstants.routesTag,
      action: MetricAction.tap.toString(),
    );

    final routes = ref.read(currentRouteProvider);

    switch (routes?.previousPath) {
      case '/poi-map':
      case '/iwish':
      case '/landing':
        context.pop();
        break;
      default:
        const RoutingRoute().pushReplacement(context);
    }
  }
}
