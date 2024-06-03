// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_positional_boolean_parameters
import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/providers/route_onboarding.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/features/stories/domain/story_types.dart';
import 'package:mapness/features/stories/stories.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/app_features.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/widgets/profile/profile_image_widget.dart';

// Stateful navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
class ScaffoldWithNestedNavigation extends ConsumerStatefulWidget {
  const ScaffoldWithNestedNavigation({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<ScaffoldWithNestedNavigation> createState() => _ScaffoldWithNestedNavigationState();
}

class _ScaffoldWithNestedNavigationState extends ConsumerState<ScaffoldWithNestedNavigation> {
  static const _tag = MetricsConstants.exploreTag;

  int currentTab = 0;

  @override
  void initState() {
    currentTab = widget.navigationShell.currentIndex;
    super.initState();
  }

  void _goToPage(int page) {
    currentTab = page;
    widget.navigationShell.goBranch(
      page,
      initialLocation: page == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) => ScaffoldWithNavigationBar(
        body: widget.navigationShell,
        currentIndex: currentTab,
        onDestinationSelected: (selected) async {
          const pageTitle = {
            0: 'profile',
            1: 'services',
            2: 'route',
            3: 'explore',
          };

          Metrics.logEventAdvanced(MetricsConstants.exploreKeys.navbarClick(pageTitle[selected] ?? 'Unknown'),
              group: _tag, action: MetricAction.tap.name);
          if (selected == 2 && ref.read(appFeaturesProvider).naviEnabled) {
            final isShowRoute = await ref.read(routeOnboardingProvider.future);
            if (isShowRoute) {
              _goToPage(selected);
            } else {
              if (!mounted) {
                return;
              }
              Stories.showOnboarding(
                context,
                StoryTypes.route,
                'route',
                onClose: () async {
                  await ref.read(routeOnboardingProvider.notifier).setShown(true);
                  _goToPage(selected);
                },
              );
            }
            return;
          }
          _goToPage(selected);
        },
      );
}

const _unselectedColor = NonThemeColor.color66;

class ScaffoldWithNavigationBar extends ConsumerWidget {
  const ScaffoldWithNavigationBar({
    required this.body,
    required this.currentIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appFeatures = ref.watch(appFeaturesProvider);
    final direction = ref.watch(uiDirectionProvider);

    final landingIndex = appFeatures.naviEnabled ? 3 : 2;
    final bottomNavigationDirection = direction == TextDirection.ltr ? TextDirection.rtl : TextDirection.ltr;

    return Directionality(
      textDirection: direction,
      child: Material(
        type: MaterialType.transparency,
        color: Colors.transparent,
        child: Column(
          children: [
            Expanded(child: body),
            Directionality(
              textDirection: bottomNavigationDirection,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: NonThemeColor.color14.withOpacity(0.05),
                      offset: const Offset(0, -2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  selectedLabelStyle: TextStyle(
                    color: context.color.strokeAccent,
                    fontSize: 0,
                    height: 0,
                  ),
                  unselectedLabelStyle: TextStyle(
                    color: context.color.textAndIconsBasePrimary,
                    fontSize: 0,
                    height: 0,
                  ),
                  items: [
                    BottomNavigationBarItem(
                      icon: _BottomNavigationBarItem(
                        selected: currentIndex == 0,
                        iconBuilder: (context, selected) => ProfileImageWidget(
                          dimension: 24,
                          color: selected ? context.color.strokeAccent : _unselectedColor,
                        ),
                        label: context.l10n.nav_profile,
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: _BottomNavigationBarItem(
                        selected: currentIndex == 1,
                        icon: 'assets/icons/svg/ic_nav_landing.svg',
                        label: context.l10n.nav_landing,
                      ),
                      label: '',
                    ),
                    if (appFeatures.naviEnabled)
                      BottomNavigationBarItem(
                        icon: _BottomNavigationBarItem(
                          selected: currentIndex == 2,
                          icon: 'assets/icons/svg/ic_nav_route.svg',
                          labelBuilder: (context, selected) => Directionality(
                            textDirection: direction,
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${context.l10n.nav_route} ',
                                    style: Theme.of(context).extension<ThemeTextStyles>()!.caption.copyWith(
                                          color: selected ? context.color.strokeAccent : _unselectedColor,
                                        ),
                                  ),
                                  SvgPicture.asset(
                                    ref.read(appLanguageProvider) == Language.arabic
                                        ? 'assets/icons/svg/beta_ar.svg'
                                        : 'assets/icons/svg/beta_en.svg',
                                    package: 'mapness',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        label: '',
                      ),
                    BottomNavigationBarItem(
                      icon: _BottomNavigationBarItem(
                        selected: currentIndex == landingIndex,
                        icon: 'assets/icons/svg/ic_nav_general.svg',
                        label: context.l10n.nav_general,
                      ),
                      label: '', //context.l10n.nav_general,
                    ),
                  ],
                  currentIndex: currentIndex,
                  onTap: onDestinationSelected,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavigationBarItem extends StatelessWidget {
  final bool selected;
  final String? icon;
  final Widget Function(BuildContext, bool)? iconBuilder;
  final String? label;
  final Widget Function(BuildContext, bool)? labelBuilder;

  const _BottomNavigationBarItem({
    required this.selected,
    this.icon,
    this.iconBuilder,
    this.label,
    this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Column(
          children: [
            iconBuilder?.call(context, selected) ??
                _DefaultIcon(
                  icon: icon!,
                  selected: selected,
                ),
            const SizedBox(height: 2),
            labelBuilder?.call(context, selected) ??
                _DefaultLabel(
                  label: label!,
                  selected: selected,
                ),
          ],
        ),
      );
}

class _DefaultIcon extends StatelessWidget {
  final String icon;
  final bool selected;

  const _DefaultIcon({
    required this.icon,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
        icon,
        height: 24,
        width: 24,
        package: 'mapness',
        colorFilter: ColorFilter.mode(
          selected ? context.color.strokeAccent : _unselectedColor,
          BlendMode.srcIn,
        ),
      );
}

class _DefaultLabel extends StatelessWidget {
  final String label;
  final bool selected;

  const _DefaultLabel({
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: Theme.of(context).extension<ThemeTextStyles>()!.caption.copyWith(
              color: selected ? context.color.strokeAccent : _unselectedColor,
            ),
      );
}
