import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';

class RoutesCarousel extends StatelessWidget {
  const RoutesCarousel({
    super.key,
    required this.pageController,
    required this.routes,
    required this.onActiveChanged,
    required this.startNavigation,
  });

  final PageController pageController;
  final List<RouteInfo> routes;
  final Function(int) onActiveChanged;
  final Function() startNavigation;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      controller: pageController,
      onPageChanged: onActiveChanged,
      itemBuilder: (BuildContext context, int index) => RouteCell(
        route: routes[index],
        // Assuming that onChanged event always fired before
        startNavigation: startNavigation,
      ),
      itemCount: routes.length,
    );
  }
}

class RouteCell extends StatelessWidget {
  const RouteCell({
    super.key,
    required this.route,
    required this.startNavigation,
  });

  final RouteInfo route;
  final Function() startNavigation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      child: Material(
        color: const Color(0x0D1E2A36),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Column(
                  children: [
                    Text(
                      route.duration.formatDuration(),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        color: const Color(0xFF1E2A36),
                      ),
                    ),
                    Text(
                      route.distance.formatDistance(),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                        color: const Color(0xFF1E2A36),
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              Material(
                color: const Color(0xFF4CA5B4),
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: startNavigation,
                  child: SizedBox(
                    width: 70,
                    height: 40,
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 14),
                        child: Text(
                          "Go",
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
