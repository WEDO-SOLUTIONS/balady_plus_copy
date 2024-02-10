// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_positional_boolean_parameters
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/providers/route_onboarding.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/profile/widgets/profile_image_widget.dart';
import 'package:mapness/_features/stories/domain/story_types.dart';
import 'package:mapness/_features/stories/stories.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_features.dart';
import 'package:mapness/shared/providers/app_language.dart';

// Stateful navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
class ScaffoldWithNestedNavigation extends ConsumerStatefulWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<ScaffoldWithNestedNavigation> createState() =>
      _ScaffoldWithNestedNavigationState();
}

class _ScaffoldWithNestedNavigationState
    extends ConsumerState<ScaffoldWithNestedNavigation> {
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
        onDestinationSelected: (int selected) async {
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
                  await ref
                      .read(routeOnboardingProvider.notifier)
                      .setShown(true);
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

const _selectedColor = Color(0xFF4CA5B4);
const _unselectedColor = Color(0x801E2A36);

class ScaffoldWithNavigationBar extends ConsumerWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appFeatures = ref.watch(appFeaturesProvider);
    final direction = ref.watch(uiDirectionProvider);

    final landingIndex = appFeatures.naviEnabled ? 3 : 2;
    final bottomNavigationDirection =
        direction == TextDirection.ltr ? TextDirection.rtl : TextDirection.ltr;

    return Directionality(
      textDirection: direction,
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            Expanded(child: body),
            Directionality(
              textDirection: bottomNavigationDirection,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                selectedLabelStyle: const TextStyle(
                  color: Color(0xFF4CA5B4),
                  fontSize: 0,
                  height: 0,
                ),
                unselectedLabelStyle: const TextStyle(
                  color: Color(0xFF1E2A36),
                  fontSize: 0,
                  height: 0,
                ),
                items: [
                  BottomNavigationBarItem(
                    icon: _BottomNavigationBarItem(
                      selected: currentIndex == 0,
                      iconBuilder: (context, selected) =>
                          const ProfileImageWidget(
                        dimension: 28,
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
                                  style: Theme.of(context)
                                      .extension<ThemeTextStyles>()!
                                      .textXS
                                      .copyWith(
                                        color: selected
                                            ? _selectedColor
                                            : _unselectedColor,
                                      ),
                                ),
                                SvgPicture.asset(
                                  ref.read(appLanguageProvider) ==
                                          Language.arabic
                                      ? 'assets/icons/svg/beta_ar.svg'
                                      : 'assets/icons/svg/beta_en.svg',
                                  package: 'mapness',
                                )
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
          ],
        ),
      ),
    );
  }
}

class _BottomNavigationBarItem extends StatelessWidget {
  final bool selected;
  final String? icon;
  final Function(BuildContext, bool)? iconBuilder;
  final String? label;
  final Function(BuildContext, bool)? labelBuilder;

  const _BottomNavigationBarItem({
    required this.selected,
    this.icon,
    this.iconBuilder,
    this.label,
    this.labelBuilder,
  });

  Widget _defaultLabelBuilder(BuildContext context, bool selected) => Text(
        label!,
        style: Theme.of(context).extension<ThemeTextStyles>()!.textXS.copyWith(
              color: selected ? _selectedColor : _unselectedColor,
            ),
      );

  Widget _defaultIconBuilder(BuildContext context, bool selected) =>
      SvgPicture.asset(
        icon!,
        height: 28,
        width: 28,
        package: 'mapness',
        colorFilter: ColorFilter.mode(
          selected ? _selectedColor : _unselectedColor,
          BlendMode.srcIn,
        ),
      );

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Column(
          children: [
            (iconBuilder ?? _defaultIconBuilder)(context, selected),
            (labelBuilder ?? _defaultLabelBuilder)(context, selected),
          ],
        ),
      );
}
