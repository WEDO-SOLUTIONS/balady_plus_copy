import 'package:balady_uikit/balady_uikit.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/routing/providers/public_transport_visibility.dart';
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
    required this.publicTransportRoutes,
    required this.onActiveChanged,
    required this.startNavigation,
    required this.refresh,
    required this.navType,
    required this.publicTransportVisibility,
    this.destination,
    this.startPoint,
    super.key,
  });

  final RouteSearchOptionsMessage navType;
  final PageController pageController;
  final AsyncValue<List<RouteInfo>> routes;
  final AsyncValue<List<BriefPublicTransportModel>> publicTransportRoutes;
  final ValueChanged<int> onActiveChanged;
  final Function(RouteInfo) startNavigation;
  final Function() refresh;
  final RouteParamsPointWithLabel? destination;
  final RouteParamsPointWithLabel? startPoint;
  final AsyncValue<PublicTransportVisibilityResult> publicTransportVisibility;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Because public transport can't build navigation, we can improve experience
    // for pedestrian routes that was found for public transport
    // Add method that call [startNavigation] for the same pedestrian route (need to get data from pedestrian route tab)
    if (navType == RouteSearchOptionsMessage.publicTransport) {
      if (publicTransportVisibility.isLoading || publicTransportRoutes.isLoading) {
        return PathCardLoading(text: context.l10n.loading, currentType: navType);
      }
      if (publicTransportVisibility.hasError || publicTransportRoutes.hasError) {
        return PathCardFailure(refresh: refresh, text: context.l10n.routeNotFound);
      }
      if (!publicTransportVisibility.value!.isPublicTransportAvailable) {
        return PathCardFailure(refresh: refresh, text: context.l10n.routeNotFound);
      }
      final routes = publicTransportRoutes.value;
      if (routes == null || routes.isEmpty) {
        return PathCardFailure(refresh: refresh, text: context.l10n.routeNotFound);
      }
      final shortest = shortestIsOnlyOnePublicTransport(routes);

      return RouteCarouselWrapper(
        pageController: pageController,
        routesCount: routes.length,
        height: navType.cardHeight,
        onActiveChanged: onActiveChanged,
        itemBuilder: (context, index) {
          final route = routes[index];
          final durationInSeconds = route.duration;
          return Padding(
            padding: padding(index: index, length: routes.length),
            child: PathPublicCard(
              route: route,
              localizations: PathCardLocalization(
                calories: context.l10n.calories,
                steps: context.l10n.steps,
                go: context.l10n.go,
              ),
              onStartNavigation: () => startNavigation(getRouteInfo(route)),
              destination: destination,
              startPoint: startPoint,
              additionalInfo: shortest != null && shortest == durationInSeconds
                  ? PathCardStatus.shortest(context.l10n.shortest)
                  : null,
              publicTransportRoutes: publicTransportRoutes.value,
              activeIndex: index,
              onActiveChanged: onActiveChanged,
            ),
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
      error: (_, __) => PathCardFailure(refresh: refresh, text: context.l10n.routeNotFound),
      loading: () => PathCardLoading(text: context.l10n.loading, currentType: navType),
      skipLoadingOnRefresh: false,
      skipLoadingOnReload: false,
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
      return const EdgeInsetsDirectional.only(
        start: Spacing.$4x,
        end: Spacing.$4x,
      );
    }
    EdgeInsetsDirectional result;
    if (index == 0) {
      result = const EdgeInsetsDirectional.only(
        start: Spacing.$4x,
        end: Spacing.$2x,
      );
    } else if (index == length - 1) {
      result = const EdgeInsetsDirectional.only(
        start: Spacing.$2x,
        end: Spacing.$4x,
      );
    } else {
      result = const EdgeInsetsDirectional.only(start: Spacing.$2x);
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
