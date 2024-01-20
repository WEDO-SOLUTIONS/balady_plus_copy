import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/app/routes/path_nav.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/routing/ui/routes_carousel.dart';
import 'package:mapness/pages/routing/lib/route_point_extension.dart';
import 'package:mapness/pages/routing/lib/route_search_options_extension.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';
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
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.rtl,
        child: DraggableScrollableSheet(
          controller: _controller,
          initialChildSize: 0.35,
          minChildSize: 0.35,
          maxChildSize: 0.35,
          builder: (context, scrollController) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.0),
                topLeft: Radius.circular(16.0),
              ),
            ),
            child: Material(
              color: const Color(0x0D1E2A36),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.0),
                    topLeft: Radius.circular(16.0),
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
                          decoration: const BoxDecoration(
                            color: Color(0xFFDDE4EE),
                            borderRadius: BorderRadius.all(Radius.circular(24)),
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
                                  searchPoints = searchPoints.reversed.toList();
                                });
                              },
                              icon: 'assets/icons/svg/ic_transition.svg',
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            NavButton(
                              onTap: () {
                                const RoutingRoute().go(context);
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
                            const PathNavRoute().go(context);
                          },
                          navType: navType,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            RouteSearchOptionsMessage.pedestrian,
                            RouteSearchOptionsMessage.car,
                          ]
                              .map(
                                (e) => _RouteSwitch(
                                  onTap: () => setState(
                                    () => navType = e,
                                  ),
                                  isChoosed: navType == e,
                                  navType: e,
                                  points: searchPoints,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class _RouteSwitch extends ConsumerWidget {
  final List<RouteSearchPointMessage?> points;
  final RouteSearchOptionsMessage navType;
  final bool isChoosed;
  final Function() onTap;

  const _RouteSwitch({
    required this.navType,
    required this.isChoosed,
    required this.onTap,
    required this.points,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = ref.watch(briefRouteInfoProvider(
      startPoint: points[0],
      finishPoint: points[1],
      navType: navType,
    ));

    return RouteTypeSwitch(
      iconAsset: navType.icon,
      title: time?.first.duration.ceil().formatDuration(context.l10n) ?? '-',
      onPressed: onTap,
      isChoosed: isChoosed,
    );
  }
}
