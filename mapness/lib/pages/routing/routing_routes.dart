import 'package:balady_uikit/balady_uikit.dart';
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
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/routing/current_route_provider.dart';
import 'package:mapness/shared/ui/buttons/nav_button.dart';
import 'package:mapness/widgets/routing/ui/route_timeline.dart';

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
  late DraggableScrollableController _controller;

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

    _controller = DraggableScrollableController();
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
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      ..watch(mapObjectManagerProvider(named: esri.name, layerId: esri.layerId)
          .notifier)
      ..watch(mapObjectManagerProvider(
              named: mappness.name, layerId: mappness.layerId)
          .notifier);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: [
          RoutingMapControls(
            bottomExtent: MediaQuery.of(context).size.height * 0.35,
          ),
          DraggableScrollableSheet(
            controller: _controller,
            initialChildSize: 0.35,
            minChildSize: 0.35,
            maxChildSize: 0.35,
            builder: (context, scrollController) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
                ),
              ),
              child: Material(
                color: NonThemeColor.color11,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Center(
                          child: Container(
                            height: 4,
                            width: 26,
                            decoration: BoxDecoration(
                              color: context.color.surfaceBasePrimary,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(24)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: RouteTimeline(
                                  labels: labels,
                                ),
                              ),
                              NavButton(
                                onTap: () {
                                  ref.read(urbiMetricsProvider.notifier).logEvent(
                                      'Routes/Route-selection/Reverse Route Direction icon => Tap');
                                  setState(() {
                                    points = points.reversed.toList();
                                    labels = labels.reversed.toList();
                                    searchPoints =
                                        searchPoints.reversed.toList();
                                  });
                                },
                                icon: 'assets/icons/svg/ic_transition.svg',
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              NavButton(
                                onTap: () {
                                  ref
                                      .read(urbiMetricsProvider.notifier)
                                      .logEvent(
                                          'Routes/Route-selection/Back => Tap');
                                  final routes = ref.read(currentRouteProvider);

                                  switch (routes?.previousPath) {
                                    case '/poi-map':
                                    case '/iwish':
                                    case '/landing':
                                      context.pop();
                                      break;
                                    default:
                                      const RoutingRoute().go(context);
                                  }
                                },
                                icon: 'assets/icons/svg/ic_search_close.svg',
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: RoutingInfo(
                            points: points,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
