import 'package:balady_uikit/balady_uikit.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/models/path_card_localization.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/models/path_card_status.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/path_card.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/path_card_failure.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/path_card_loading.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/tools/path_card_size.dart';

class RoutesCarousel extends ConsumerWidget {
  const RoutesCarousel({
    required this.pageController,
    required this.routes,
    required this.onActiveChanged,
    required this.startNavigation,
    required this.refresh,
    required this.navType,
    super.key,
  });

  final RouteSearchOptionsMessage navType;
  final PageController pageController;
  final AsyncValue<List<RouteInfo>> routes;
  final ValueChanged<int> onActiveChanged;
  final Function(RouteInfo) startNavigation;
  final Function() refresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) => routes.when(
        data: (routes) {
          final shortest = shortestIsOnlyOne(routes);
          return _CarouselWrapper(
            pageController: pageController,
            routes: routes,
            height: PathCardSize.getCardHeight(isPedestrian: navType == RouteSearchOptionsMessage.pedestrian),
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
                padding: padding(
                  index: index,
                  length: routes.length,
                  isLtr: Directionality.of(context) == TextDirection.ltr,
                ),
                child: PathCard(
                  distance: distanceInMeters.formatDistance(context.l10n),
                  isPedestrian: navType == RouteSearchOptionsMessage.pedestrian,
                  localizations: PathCardLocalization(
                    calories: context.l10n.calories,
                    steps: context.l10n.steps,
                    go: context.l10n.go,
                  ),
                  duration: durationInSeconds.formatDuration(context.l10n),
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

  /// We use it to show the badge "Shortest" on only one shortest route
  /// If we have more then one shortest route we don't show the badge and return null
  int? shortestIsOnlyOne(List<RouteInfo> routes) {
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
  EdgeInsets padding({required int index, required int length, required bool isLtr}) {
    if (length == 1) {
      return const EdgeInsets.only(
        left: Spacing.$4x,
        right: Spacing.$4x,
      );
    }
    EdgeInsets result;
    if (index == 0) {
      result = const EdgeInsets.only(
        left: Spacing.$4x,
        right: Spacing.$2x / 2,
      );
    } else if (index == length - 1) {
      result = const EdgeInsets.only(
        left: Spacing.$2x / 2,
        right: Spacing.$4x,
      );
    } else {
      result = const EdgeInsets.symmetric(horizontal: Spacing.$2x / 2);
    }
    return isLtr ? result : result.flipped;
  }
}

/// This widget is used to wrap in [PageView] cards if amount of cards is more then one
/// If amount is more then one we set the default width for [PathCard] (but we set it earlier when we setup [PageController] and [viewportFraction])
class _CarouselWrapper extends StatelessWidget {
  final double height;
  final PageController pageController;
  final List<RouteInfo> routes;
  final ValueChanged<int> onActiveChanged;
  final Widget Function(BuildContext, int) itemBuilder;

  const _CarouselWrapper({
    required this.itemBuilder,
    required this.routes,
    required this.height,
    required this.pageController,
    required this.onActiveChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (routes.length == 1) {
      return itemBuilder(context, 0);
    }
    return SizedBox(
      height: height,
      child: PageView.builder(
        controller: pageController,
        onPageChanged: onActiveChanged,
        padEnds: false,
        itemBuilder: itemBuilder,
        itemCount: routes.length,
      ),
    );
  }
}
