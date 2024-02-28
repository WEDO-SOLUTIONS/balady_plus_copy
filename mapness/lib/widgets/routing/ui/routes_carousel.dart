import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';
import 'package:mapness/shared/ui/loading/loading_small.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';

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
        data: (routes) => PageView.builder(
          controller: pageController,
          onPageChanged: onActiveChanged,
          itemBuilder: (context, index) => RouteCell(
            navType: navType,
            route: routes[index],
            // Assuming that onChanged event always fired before
            startNavigation: startNavigation,
          ),
          itemCount: routes.length,
        ),
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
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .textM
                      .copyWith(
                        color: context.color.text_and_icons_base_primary,
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
        loading: () => IgnorePointer(
          child: PageView.builder(
            controller: pageController,
            onPageChanged: onActiveChanged,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
              ),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: NonThemeColor.color11,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: LoadingSmall(),
                  ),
                ),
              ),
            ),
            itemCount: 3,
          ),
        ),
        skipLoadingOnRefresh: false,
        skipLoadingOnReload: false,
      );
}

class RouteCell extends ConsumerWidget {
  const RouteCell({
    required this.route,
    required this.startNavigation,
    super.key, required this.navType,
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
    final calories = (duration * averageCaloriesPerMinute).toInt();

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
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()!
                              .accentM
                              .copyWith(
                                color:
                                    context.color.text_and_icons_base_primary,
                              ),
                        ),
                        Text(
                          distance.formatDistance(context.l10n),
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()!
                              .textS
                              .copyWith(
                                color:
                                    context.color.text_and_icons_base_primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Material(
                    color: context.color.stroke_accent,
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
                              style: Theme.of(context)
                                  .extension<ThemeTextStyles>()!
                                  .accentXS
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (navType == RouteSearchOptionsMessage.pedestrian) Row(
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
              ) else SizedBox.shrink(),
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
    super.key,
    required this.title,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        SizedBox(width: 3),
        Text(
          title,
          style: context.textStyle.textS
              .copyWith(color: context.color.text_and_icons_base_primary),
        ),
        SizedBox(width: 3),
        Text(
          '$count',
          style: context.textStyle.textS
              .copyWith(color: context.color.text_and_icons_base_tertiary),
        ),
      ],
    );
  }
}
