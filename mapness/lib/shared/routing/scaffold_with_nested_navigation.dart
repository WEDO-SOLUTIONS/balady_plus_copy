// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/_features/map/providers/dgis_controller.dart';

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

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithNavigationBar(
      body: widget.navigationShell,
      currentIndex: currentTab,
      onDestinationSelected: (int selected) {
        int index = selected;
        if (index == 2) {
          index = 3;
          ref
              .read(mapControlsProvider.notifier)
              .update(MapControlsStateNavigation());
        } else if (currentTab == 2) {
          ref
              .watch(mapControlsProvider.notifier)
              .update(MapControlsStateIdle());
          try {
            ref.watch(dgisControllerProvider)?.hideRoutes();
            ref.watch(dgisControllerProvider)?.stopNavigation();
          } catch (e) {}
        }
        currentTab = selected;
        widget.navigationShell.goBranch(
          index,
          // A common pattern when using bottom navigation bars is to support
          // navigating to the initial location when tapping the item that is
          // already active. This example demonstrates how to support this behavior,
          // using the initialLocation parameter of goBranch.
          initialLocation: index == widget.navigationShell.currentIndex,
        );
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

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Column(
        children: [
          Expanded(child: body),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: CupertinoTabBar(
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                backgroundColor: Colors.white,
                border: null,
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      "assets/icons/svg/ic_nav_profile.svg",
                      semanticsLabel: 'MinApps Screen',
                      package: "mapness",
                      colorFilter: ColorFilter.mode(
                        currentIndex == 0 ? activeColor : inactiveColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: 'المتجر',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      "assets/icons/svg/ic_nav_landing.svg",
                      semanticsLabel: 'MinApps Screen',
                      package: "mapness",
                      colorFilter: ColorFilter.mode(
                        currentIndex == 1 ? activeColor : inactiveColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: 'الخدمات',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      "assets/icons/svg/ic_nav_route.svg",
                      semanticsLabel: 'Routing Screen',
                      package: "mapness",
                      colorFilter: ColorFilter.mode(
                        currentIndex == 2 ? activeColor : inactiveColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: 'رحلتي',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      "assets/icons/svg/ic_nav_general.svg",
                      semanticsLabel: 'General Screen',
                      package: "mapness",
                      colorFilter: ColorFilter.mode(
                        currentIndex == 3 ? activeColor : inactiveColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: 'إستكشف',
                  ),
                ],
                currentIndex: currentIndex,
                onTap: onDestinationSelected,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
