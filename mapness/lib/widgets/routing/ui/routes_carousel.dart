import 'package:balady_uikit/balady_uikit.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/routing/providers/public_transport_visibility.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/features/routing/providers/routes_update_tab.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';
import 'package:mapness/widgets/routing/ui/route_carusel_wrapper.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/models/path_card_localization.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/models/path_card_status.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/path_card.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/path_card_failure.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/path_card_loading.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/path_public_card.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/tools/path_card_size.dart';

class RoutesCarousel extends ConsumerWidget {
  const RoutesCarousel({
    required this.pageController,
    required this.routes,
    required this.onActiveChanged,
    required this.startNavigation,
    required this.refresh,
    required this.navType,
    required this.publicTransportVisibility,
    required this.points,
    super.key,
  });

  final RouteSearchOptionsMessage navType;
  final PageController pageController;
  final AsyncValue<List<RouteInfo>> routes;
  final ValueChanged<int> onActiveChanged;
  final Function(RouteInfo) startNavigation;
  final Function() refresh;
  final List<RouteParamsPointWithLabel?> points;
  final AsyncValue<PublicTransportVisibilityResult> publicTransportVisibility;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (navType == RouteSearchOptionsMessage.publicTransport) {
      final startPoint = points.first?.value;
      final finishPoint = points.last?.value;
      final intermediatePoints = points.getIntermediatePointsWithLabels();

      final publicTransportRoutes = ref.watch(
        publicTransportRoutesProvider(
          startPoint: startPoint,
          finishPoint: finishPoint,
          navType: navType,
          intermediatePoints: intermediatePoints,
        ),
      );

      final publicTransport = publicTransportVisibility.asData?.value;
      final hasVisibilityError = publicTransportVisibility.hasError;
      final visibilityError = publicTransportVisibility.error;

      // Check for specific visibility errors first
      if (publicTransport?.reason == PublicTransportVisibilityReason.findRouteError) {
        return PathCardFailure.nearestMetroTooFar(
          refresh: () {
            ref.read(routesUpdateTabProvider.notifier).update = RouteSearchOptionsMessage.car;
          },
          text: context.l10n.nearestMetroTooFar,
          labelButton: context.l10n.goByCar,
        );
      }

      return publicTransportRoutes.when(
        loading: () => PathCardLoading(text: context.l10n.loading, currentType: navType),
        error: (err, st) {
          // Check for NoInternetException from either provider
          if (err is NoInternetException || (hasVisibilityError && visibilityError is NoInternetException)) {
            return PathCardFailure.noInternet(refresh: refresh, text: context.l10n.noInternetConnection);
          }

          // If visibility check returned findRouteError reason, show that error
          // This ensures the error message doesn't change after timeout
          if (publicTransport?.reason == PublicTransportVisibilityReason.findRouteError) {
            return PathCardFailure.nearestMetroTooFar(
              refresh: () {
                ref.read(routesUpdateTabProvider.notifier).update = RouteSearchOptionsMessage.car;
              },
              text: context.l10n.nearestMetroTooFar,
              labelButton: context.l10n.goByCar,
            );
          }

          // Default to route not found for any other error
          return PathCardFailure.routeNotFound(refresh: refresh, text: context.l10n.routeNotFound);
        },
        data: (ptRoutes) {
          // Filter out walking-only routes: routes where every segment has no transit stops
          final transitRoutes = ptRoutes
              .where(
                (route) =>
                    route.publicTransportTransferRouteLongEntry.any((entry) => entry.value.routeParts.isNotEmpty),
              )
              .toList();

          if (transitRoutes.isEmpty || publicTransportVisibility.hasError) {
            return PathCardFailure.nearestMetroTooFar(
              refresh: () {
                ref.read(routesUpdateTabProvider.notifier).update = RouteSearchOptionsMessage.car;
              },
              text: context.l10n.nearestMetroTooFar,
              labelButton: context.l10n.goByCar,
            );
          }

          final shortest = shortestIsOnlyOnePublicTransport(transitRoutes);

          return RouteCarouselWrapper(
            pageController: pageController,
            routesCount: transitRoutes.length,
            height: navType.cardHeight,
            onActiveChanged: onActiveChanged,
            itemBuilder: (context, index) {
              final route = transitRoutes[index];
              final durationInSeconds = route.duration;
              return Padding(
                padding: padding(index: index, length: transitRoutes.length),
                child: PathPublicCard(
                  route: route,
                  localizations: PathCardLocalization(
                    calories: context.l10n.calories,
                    steps: context.l10n.steps,
                    go: context.l10n.go,
                  ),
                  onStartNavigation: () => startNavigation(getRouteInfo(route)),
                  destination: points.lastOrNull,
                  startPoint: points.firstOrNull,
                  additionalInfo: shortest != null && shortest == durationInSeconds
                      ? PathCardStatus.shortest(context.l10n.shortest)
                      : null,
                  publicTransportRoutes: transitRoutes,
                  activeIndex: index,
                  onActiveChanged: onActiveChanged,
                ),
              );
            },
          );
        },
      );
    }

    return routes.when(
      data: (routes) {
        final shortest = shortestIsOnlyOne(routes);
        return RouteCarouselWrapper(
          pageController: pageController,
          routesCount: routes.length,
          height: navType.cardHeight,
          onActiveChanged: onActiveChanged,
          itemBuilder: (context, index) {
            final route = routes[index];
            final distanceInMeters = route.distance;
            final durationInSeconds = route.duration;

            const averageHumanStepsByKm = 1350;
            const averageCaloriesPerMinute = 4.6;

            final steps = ((distanceInMeters / 1000) * averageHumanStepsByKm).toInt();
            final calories = ((durationInSeconds / 60.0) * averageCaloriesPerMinute).toInt();
            return Padding(
              padding: padding(index: index, length: routes.length),
              child: PathCard(
                distance: distanceInMeters.formatDistanceShort(context.l10n),
                isPedestrian: navType == RouteSearchOptionsMessage.pedestrian,
                localizations: PathCardLocalization(
                  calories: context.l10n.calories,
                  steps: context.l10n.steps,
                  go: context.l10n.go,
                ),
                duration: durationInSeconds.formatDurationShort(context.l10n),
                steps: steps,
                calories: calories,
                onStartTap: () => startNavigation(route),
                additionalInfo: shortest != null && shortest == durationInSeconds
                    ? PathCardStatus.shortest(context.l10n.shortest)
                    : null,
              ),
            );
          },
        );
      },
      error: (error, __) {
        if (error is NoInternetException) {
          return PathCardFailure.noInternet(refresh: refresh, text: context.l10n.noInternetConnection);
        } else if (error is WalkingDistanceException) {
          return PathCardFailure.walkingDistance(
            refresh: () {
              ref.read(routesUpdateTabProvider.notifier).update = RouteSearchOptionsMessage.car;
            },
            text: context.l10n.walkingDistanceTooLong,
            labelButton: context.l10n.goByCar,
          );
        }

        return PathCardFailure.routeNotFound(refresh: refresh, text: context.l10n.routeNotFound);
      },
      loading: () => PathCardLoading(text: context.l10n.loading, currentType: navType),
    );
  }

  /// We use it to show the badge "Shortest" on only one shortest route
  /// If we have more then one shortest route we don't show the badge and return null
  int? shortestIsOnlyOne(List<RouteInfo> routes) {
    if (routes.isEmpty) {
      return null;
    }
    if (routes.length == 1) {
      return routes.first.duration;
    }
    final durations = routes.map((e) => e.duration).sorted((a, b) => a.compareTo(b));

    final shortestDuration = durations.first;
    if (durations[1] == shortestDuration) {
      return null;
    }
    return shortestDuration;
  }

  int? shortestIsOnlyOnePublicTransport(List<BriefPublicTransportModel> routes) {
    if (routes.isEmpty) {
      return null;
    }
    if (routes.length == 1) {
      return routes.first.duration;
    }
    final durations = routes.map((e) => e.duration).sorted((a, b) => a.compareTo(b));

    final shortestDuration = durations.first;
    if (durations[1] == shortestDuration) {
      return null;
    }
    return shortestDuration;
  }

  /// We use it to calculate padding for the first and last elements in the [PageView]
  /// Because [PageView] doesn't have a separated constructor, we need to calculate padding manually
  ///
  /// Also we use it for single element in the list to unify the padding for all cases
  EdgeInsetsDirectional padding({required int index, required int length}) {
    if (length == 1) {
      return const EdgeInsetsDirectional.only(start: Spacing.$4x, end: Spacing.$4x);
    }
    EdgeInsetsDirectional result;
    if (index == 0) {
      result = const EdgeInsetsDirectional.only(start: Spacing.$4x, end: Spacing.$1x);
    } else if (index == length - 1) {
      result = const EdgeInsetsDirectional.only(start: Spacing.$1x, end: Spacing.$4x);
    } else {
      result = const EdgeInsetsDirectional.only(start: Spacing.$1x, end: Spacing.$1x);
    }
    return result;
  }

  RouteInfo getRouteInfo(BriefPublicTransportModel route) => RouteInfo(
    route.publicTransportTransferRouteLongEntry.fold(0, (acc, e) => acc + e.length.millimeters) / 1000,
    route.duration,
    0,
    0,
    [],
  );
}
