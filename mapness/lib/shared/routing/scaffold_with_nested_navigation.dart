// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_positional_boolean_parameters
import 'package:balady_uikit/balady_uikit.dart' hide Stories;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/providers/route_onboarding.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/features/stories/domain/story_types.dart';
import 'package:mapness/features/stories/stories.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/app_features.dart';
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

          Metrics.logEventAdvanced(
            MetricsConstants.exploreKeys.navbarClick(pageTitle[selected] ?? 'Unknown'),
            group: _tag,
            action: MetricAction.tap.name,
          );
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
                          color: selected ? context.color.strokeAccent : context.color.textAndIconsBaseTertiary,
                        ),
                        label: context.l10n.nav_profile,
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: _BottomNavigationBarItem(
                        selected: currentIndex == 1,
                        iconBuilder: (ctx, isSelected) => _DefaultIcon(
                          icon: GeneralIcons.dashboard,
                          selected: isSelected,
                        ),
                        label: context.l10n.nav_landing,
                      ),
                      label: '',
                    ),
                    if (appFeatures.naviEnabled)
                      BottomNavigationBarItem(
                        icon: _BottomNavigationBarItem(
                          selected: currentIndex == 2,
                          iconBuilder: (ctx, isSelected) => _DefaultIcon(
                            icon: GeneralIcons.routeStroke,
                            selected: isSelected,
                          ),
                          label: context.l10n.nav_route,
                        ),
                        label: '',
                      ),
                    BottomNavigationBarItem(
                      icon: _BottomNavigationBarItem(
                        selected: currentIndex == landingIndex,
                        iconBuilder: (ctx, isSelected) => _DefaultIcon(
                          icon: GeneralIcons.pin_1,
                          selected: isSelected,
                        ),
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
  final Widget Function(BuildContext, bool) iconBuilder;
  final String? label;

  const _BottomNavigationBarItem({
    required this.selected,
    required this.iconBuilder,
    this.label,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Column(
          children: [
            iconBuilder.call(context, selected),
            const SizedBox(height: 2),
            _DefaultLabel(
              label: label!,
              selected: selected,
            ),
          ],
        ),
      );
}

class _DefaultIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;

  const _DefaultIcon({
    required this.icon,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) => Icon(
        icon,
        size: 24,
        color: selected ? context.color.strokeAccent : context.color.textAndIconsBaseTertiary,
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
              color: selected ? context.color.strokeAccent : context.color.textAndIconsBaseTertiary,
            ),
      );
}
