// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';
import 'package:mapness/features/map/providers/dgis_controller.dart';

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
      onDestinationSelected: (int index) {
        currentTab = index;
        if (index == 1) {
          index = 2;
          ref
              .read(mapControlsProvider.notifier)
              .update(MapControlsStateNavigation());
        } else {
          ref
              .watch(mapControlsProvider.notifier)
              .update(MapControlsStateIdle());
          try {
            ref.watch(dgisControllerProvider)?.hideRoutes();
            ref.watch(dgisControllerProvider)?.stopNavigation();
          } catch (e) {}
        }
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
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Column(
        children: [
          Expanded(child: body),
          CupertinoTabBar(
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/svg/ic_nav_profile.svg",
                  semanticsLabel: 'Profile Screen',
                  package: "mapness",
                ),
                label: 'المتجر',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/svg/ic_nav_route.svg",
                  semanticsLabel: 'Routing Screen',
                  package: "mapness",
                ),
                label: 'رحلتي',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/svg/ic_nav_landing.svg",
                  semanticsLabel: 'MinApps Screen',
                  package: "mapness",
                ),
                label: 'الخدمات',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/svg/ic_nav_general.svg",
                  semanticsLabel: 'General Screen',
                  package: "mapness",
                ),
                label: 'إستكشف',
              ),
            ],
            currentIndex: currentIndex,
            onTap: onDestinationSelected,
          ),
        ],
      ),
    );
  }
}
