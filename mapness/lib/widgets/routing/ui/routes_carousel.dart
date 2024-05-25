import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/models/path_card_localization.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/path_card.dart';
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
              padding: const EdgeInsets.only(
                left: Spacing.horizontalPaddingInsideWrapper,
                right: Spacing.horizontalPaddingInsideWrapper,
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

          return SizedBox(
            height: PathCardSize.getCardHeight(isPedestrian: navType == RouteSearchOptionsMessage.pedestrian),
            child: PageView.builder(
              controller: routes.length == 1 ? PageController() : pageController,
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
                  ),
                );
              },
              itemCount: routes.length,
            ),
          );
        }),
        error: (_, __) => Directionality(
          textDirection: ref.watch(uiDirectionProvider),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.routeNotFound,
                  style: Theme.of(context).extension<ThemeTextStyles>()!.text.copyWith(
                        color: context.color.textAndIconsBasePrimary,
                      ),
                ),
                const SizedBox(
                  height: 8,
                ),
                LabeledElevatedButton(
                  label: context.l10n.reload,
                  onPressed: refresh,
                ),
              ],
            ),
          ),
        ),
        loading: () => PathCardLoading(text: context.l10n.loading),
        skipLoadingOnRefresh: false,
        skipLoadingOnReload: false,
      );

  EdgeInsets padding({required int index, required int length, required bool isLtr}) {
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

class RouteCell extends ConsumerWidget {
  const RouteCell({
    required this.route,
    required this.startNavigation,
    required this.navType,
    super.key,
  });

  final RouteSearchOptionsMessage navType;
  final RouteInfo route;
  final Function() startNavigation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final direction = ref.watch(uiDirectionProvider);
    final distance = route.distance;
    final duration = route.duration;

    const averageHumanStepsByKm = 1350;
    const averageCaloriesPerMinute = 4.6;

    final steps = ((distance / 1000) * averageHumanStepsByKm).toInt();
    final calories = ((duration / 60.0) * averageCaloriesPerMinute).toInt();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      child: Material(
        color: NonThemeColor.color11,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Directionality(
                    textDirection: direction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          duration.formatDuration(context.l10n),
                          style: Theme.of(context).extension<ThemeTextStyles>()!.callout.copyWith(
                                color: context.color.textAndIconsBasePrimary,
                              ),
                        ),
                        Text(
                          distance.formatDistance(context.l10n),
                          style: Theme.of(context).extension<ThemeTextStyles>()!.footNote.copyWith(
                                color: context.color.textAndIconsBasePrimary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Material(
                    color: context.color.strokeAccent,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: startNavigation,
                      child: SizedBox(
                        width: 70,
                        height: 40,
                        child: Align(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 14,
                            ),
                            child: Text(
                              context.l10n.go,
                              style:
                                  Theme.of(context).extension<ThemeTextStyles>()!.caption.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (navType == RouteSearchOptionsMessage.pedestrian)
                Row(
                  children: [
                    HealthInfo(
                      title: context.l10n.steps,
                      count: steps,
                      icon: SvgPicture.asset(
                        'assets/icons/svg/steps.svg',
                        package: PackageConfig.packageName,
                        height: 16,
                        width: 16,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    HealthInfo(
                      title: context.l10n.calories,
                      count: calories,
                      icon: SvgPicture.asset(
                        'assets/icons/svg/calories.svg',
                        package: PackageConfig.packageName,
                        height: 16,
                        width: 16,
                      ),
                    ),
                  ],
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

class HealthInfo extends StatelessWidget {
  final String title;
  final int count;
  final Widget icon;

  const HealthInfo({
    required this.title,
    required this.count,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          icon,
          const SizedBox(width: 3),
          Text(
            title,
            style: context.textStyle.footNote.copyWith(color: context.color.textAndIconsBasePrimary),
          ),
          const SizedBox(width: 3),
          Text(
            '$count',
            style: context.textStyle.footNote.copyWith(color: context.color.textAndIconsBaseTertiary),
          ),
        ],
      );
}
