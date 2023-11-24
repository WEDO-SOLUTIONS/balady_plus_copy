import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/app/routes/path_nav.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/routing/ui/routes_carousel.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/config/package_fonts.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
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

  @override
  void initState() {
    super.initState();
    points = widget.points;
    labels = widget.labels;
    _controller = DraggableScrollableController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    ref.read(dgisControllerProvider)?.hideRoutes();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
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
                              });
                            },
                            icon: "assets/icons/svg/ic_transition.svg",
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          NavButton(
                            onTap: () {
                              const RoutingRoute().go(context);
                            },
                            icon: "assets/icons/svg/ic_search_close.svg",
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
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Material(
                            color: const Color(0x0D1E2A36),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 12,
                                top: 6,
                                bottom: 6,
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/svg/ic_routing_car.svg',
                                    height: 30,
                                    package: PackageConfig.packageName,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    "4 دقائق",
                                    style: PackageFonts.frutigerArabic(
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w700,
                                      height: 1.3,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
