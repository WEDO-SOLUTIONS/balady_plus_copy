import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/app/routes/path_nav.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/features/routing/ui/routes_carousel.dart';
import 'package:mapness/pages/routing/lib/route_point_extension.dart';
import 'package:mapness/pages/routing/lib/route_search_options_extension.dart';
import 'package:mapness/pages/routing/ui/routing_map_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/routing/current_route_provider.dart';
import 'package:mapness/shared/ui/buttons/nav_button.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';
import 'package:mapness/widgets/routing/ui/route_timeline.dart';
import 'package:mapness/widgets/routing/ui/route_type_switch.dart';

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
  RouteSearchOptionsMessage navType = RouteSearchOptionsMessage.car;

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
    ref.watch(locationProvider);

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
                              color: context.color.surface_base_primary,
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
                                  final routes = ref.read(currentRouteProvider);

                                  switch (routes?.previousPath) {
                                    case '/poi-map':
                                    case '/iwish':
                                    case '/landing':
                                      const LandingRoute().go(context);
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
                        const SizedBox(
                          height: 16,
                        ),
                        Expanded(
                          child: RoutesCarousel(
                            points: points,
                            startNavigation: () {
                              PathNavRoute.open(
                                ref.watch(goRouterProvider),
                                navType,
                              );
                            },
                            navType: navType,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _RouteTabBar(
                          active: navType,
                          onChanged: (e) {
                            setState(() {
                              navType = e;
                            });
                          },
                          points: points,
                        ),
                        const SizedBox(height: 16),
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

class _RouteTabBar extends ConsumerWidget {
  const _RouteTabBar({
    required this.onChanged,
    required this.active,
    required this.points,
  });
  final void Function(RouteSearchOptionsMessage) onChanged;
  final RouteSearchOptionsMessage active;
  final List<RouteParamsPoint?> points;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref
            .watch(
              routesProvider(
                startPoint: points[0],
                finishPoint: points[1],
                navType: active,
              ),
            )
            .unwrapPrevious()
            .valueOrNull ??
        [];
    final activeRoute = ref.watch(activeRouteProvider);
    final routeDuration = routes.isEmpty ? null : routes[activeRoute].duration;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          RouteSearchOptionsMessage.pedestrian,
          RouteSearchOptionsMessage.car,
        ]
            .map(
              (e) => RouteTypeSwitch(
                iconAsset: e.icon,
                title: active == e
                    ? routeDuration?.formatDuration(context.l10n)
                    : null,
                onPressed: () => onChanged(e),
                isChoosed: active == e,
              ),
            )
            .toList(),
      ),
    );
  }
}
