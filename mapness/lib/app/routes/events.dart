import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/features/road_events/ui/road_closure_page.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'events.g.dart';

@TypedGoRoute<EventsRoute>(
  path: '/road-events',
)
class EventsRoute extends GoRouteData {
  const EventsRoute({
    required this.title,
    required this.description,
    required this.startTime,
    required this.finishTime,
    required this.latitude,
    required this.longitude,
  });

  final String title;
  final String description;
  final DateTime? startTime;
  final DateTime? finishTime;
  final double latitude;
  final double longitude;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  static void open(BuildContext context, RoadEventTapEvent event) {
    final eventsRoute = EventsRoute(
      title: event.title,
      description: event.description,
      startTime: event.startTime,
      finishTime: event.finishTime,
      latitude: event.latLng.latitude,
      longitude: event.latLng.longitude,
    );
    final router = GoRouter.of(context);
    final matches = router.routerDelegate.currentConfiguration.matches;
    if (matches.last.matchedLocation == '/road-events') {
      eventsRoute.pushReplacement(context);
    } else {
      eventsRoute.push(context);
    }
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      TransculentPage(
        child: MediaQuery(
          data: MediaQuery.of(context),
          child: Material(
            type: MaterialType.transparency,
            color: Colors.transparent,
            child: Directionality(
              textDirection: Directionality.of(context),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RoadClosurePage(
                  title: title,
                  description: description,
                  startTime: startTime,
                  finishTime: finishTime,
                  latitude: latitude,
                  longitude: longitude,
                ),
              ),
            ),
          ),
        ),
      );
}

final $eventRoutes = $appRoutes;
