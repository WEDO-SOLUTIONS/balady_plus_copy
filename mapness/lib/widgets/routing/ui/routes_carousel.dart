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
  final Function(int) onActiveChanged;
  final Function() startNavigation;
  final Function() refresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) => routes.when(
        data: (routes) => Builder(builder: (context) {
          if (routes.length == 1) {
            final route = routes.first;
            final distance = route.distance;
            final duration = route.duration;

            const averageHumanStepsByKm = 1350;
            const averageCaloriesPerMinute = 4.6;

            final steps = ((distance / 1000) * averageHumanStepsByKm).toInt();
            final calories = ((duration / 60.0) * averageCaloriesPerMinute).toInt();
            return Padding(
              padding: padding(
                index: 0,
                length: routes.length,
                isLtr: Directionality.of(context) == TextDirection.ltr,
              ),
              child: PathCard(
                distance: distance.formatDistance(context.l10n),
                isPedestrian: navType == RouteSearchOptionsMessage.pedestrian,
                localizations: PathCardLocalization(
                  calories: context.l10n.calories,
                  steps: context.l10n.steps,
                  go: context.l10n.go,
                ),
                duration: duration.formatDuration(context.l10n),
                steps: steps,
                calories: calories,
                onStartTap: startNavigation,
              ),
            );
          }
          final shortest = shortestIsOnlyOne(routes);
          return SizedBox(
            height: PathCardSize.getCardHeight(isPedestrian: navType == RouteSearchOptionsMessage.pedestrian),
            child: PageView.builder(
              controller: pageController,
              padEnds: false,
              itemBuilder: (context, index) {
                final route = routes[index];
                final distance = route.distance;
                final duration = route.duration;

                const averageHumanStepsByKm = 1350;
                const averageCaloriesPerMinute = 4.6;

                final steps = ((distance / 1000) * averageHumanStepsByKm).toInt();
                final calories = ((duration / 60.0) * averageCaloriesPerMinute).toInt();
                return Padding(
                  padding: padding(
                    index: index,
                    length: routes.length,
                    isLtr: Directionality.of(context) == TextDirection.ltr,
                  ),
                  child: PathCard(
                    distance: distance.formatDistance(context.l10n),
                    isPedestrian: navType == RouteSearchOptionsMessage.pedestrian,
                    localizations: PathCardLocalization(
                      calories: context.l10n.calories,
                      steps: context.l10n.steps,
                      go: context.l10n.go,
                    ),
                    duration: duration.formatDuration(context.l10n),
                    steps: steps,
                    calories: calories,
                    onStartTap: startNavigation,
                    additionalInfo: shortest != null && shortest == duration
                        ? PathCardStatus.shortest(context.l10n.shortest)
                        : null,
                  ),
                );
              },
              itemCount: routes.length,
            ),
          );
        }),
        error: (_, __) => PathCardFailure(refresh: refresh),
        loading: () => PathCardLoading(text: context.l10n.loading),
        skipLoadingOnRefresh: false,
        skipLoadingOnReload: false,
      );

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

  EdgeInsets padding({required int index, required int length, required bool isLtr}) {
    if (length == 1) {
      return const EdgeInsets.only(
        left: Spacing.horizontalPaddingInsideWrapper,
        right: Spacing.horizontalPaddingInsideWrapper,
      );
    }
    EdgeInsets result;
    if (index == 0) {
      result = const EdgeInsets.only(
        left: Spacing.horizontalPaddingInsideWrapper,
        right: Spacing.horizontalGapBetweenChips / 2,
      );
    } else if (index == length - 1) {
      result = const EdgeInsets.only(
        left: Spacing.horizontalGapBetweenChips / 2,
        right: Spacing.horizontalPaddingInsideWrapper,
      );
    } else {
      result = const EdgeInsets.symmetric(horizontal: Spacing.horizontalGapBetweenChips / 2);
    }
    return isLtr ? result : result.flipped;
  }
}

class _CarouselWrapper extends StatelessWidget {
  const _CarouselWrapper();

  @override
  Widget build(BuildContext context) => const Placeholder();
}
