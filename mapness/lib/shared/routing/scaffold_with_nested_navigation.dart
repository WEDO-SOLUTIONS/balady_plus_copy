// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/providers/route_onboarding.dart';
import 'package:mapness/_features/profile/widgets/profile_image_widget.dart';
import 'package:mapness/_features/stories/domain/story_types.dart';
import 'package:mapness/_features/stories/stories.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

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
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: page == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithNavigationBar(
      body: widget.navigationShell,
      currentIndex: currentTab,
      onDestinationSelected: (int selected) async {
        if (selected == 2) {
          final isShowRoute = await ref.read(routeOnboardingProvider.future);
          if (isShowRoute) {
            _goToPage(selected);
          } else {
            if (!mounted) return;
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
}

class ScaffoldWithNavigationBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF4CA5B4);
    const inactiveColor = Color(0x801E2A36);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            Expanded(child: body),
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: const TextStyle(
                color: Color(0xFF4CA5B4),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.5,
                fontFamily: "Frutiger",
              ),
              unselectedLabelStyle: const TextStyle(
                color: Color(0xFF1E2A36),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.5,
                fontFamily: "Frutiger",
              ),
              items: [
                BottomNavigationBarItem(
                  icon: const ProfileImageWidget(
                    dimension: 28,
                  ),
                  label: context.l10n.nav_profile,
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/svg/ic_nav_landing.svg",
                    height: 28,
                    width: 28,
                    semanticsLabel: 'MinApps Screen',
                    package: "mapness",
                    colorFilter: ColorFilter.mode(
                      currentIndex == 1 ? activeColor : inactiveColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: context.l10n.nav_landing,
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/svg/ic_nav_route.svg",
                    height: 28,
                    width: 28,
                    semanticsLabel: 'Routing Screen',
                    package: "mapness",
                    colorFilter: ColorFilter.mode(
                      currentIndex == 2 ? activeColor : inactiveColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: context.l10n.nav_route,
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/svg/ic_nav_general.svg",
                    height: 28,
                    width: 28,
                    semanticsLabel: 'General Screen',
                    package: "mapness",
                    colorFilter: ColorFilter.mode(
                      currentIndex == 3 ? activeColor : inactiveColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: context.l10n.nav_general,
                ),
              ],
              currentIndex: currentIndex,
              onTap: onDestinationSelected,
            ),
          ],
        ),
      ),
    );
  }
}
