import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
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
    super.key,
  });

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
                          color: context.color.text_and_icons_base_primary,),
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
    super.key,
  });

  final RouteInfo route;
  final Function() startNavigation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final direction = ref.watch(uiDirectionProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      child: Material(
        color: NonThemeColor.color11,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Directionality(
                textDirection: direction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.duration.formatDuration(context.l10n),
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .accentM
                          .copyWith(
                              color: context.color.text_and_icons_base_primary,),
                    ),
                    Text(
                      route.distance.formatDistance(context.l10n),
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .textS
                          .copyWith(
                              color: context.color.text_and_icons_base_primary,),
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
                            vertical: 10, horizontal: 14,),
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
        ),
      ),
    );
  }
}
