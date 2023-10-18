// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

// Stateful navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (size.width < 450) {
      return ScaffoldWithNavigationBar(
        body: navigationShell,
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
      );
    } else {
      return ScaffoldWithNavigationRail(
        body: navigationShell,
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
      );
    }
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
                  "assets/icons/svg/ic_nav_qibla.svg",
                  semanticsLabel: 'Qibla Screen',
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
                  "assets/icons/svg/ic_nav_general.svg",
                  semanticsLabel: 'General Screen',
                  package: "mapness",
                ),
                label: 'إستكشف',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/svg/ic_nav_landing.svg",
                  semanticsLabel: 'MinApps Screen',
                  package: "mapness",
                ),
                label: 'الخدمات',
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

class ScaffoldWithNavigationRail extends StatelessWidget {
  const ScaffoldWithNavigationRail({
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
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: <NavigationRailDestination>[
              NavigationRailDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: Text('Profile'),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.dashboard_outlined),
                selectedIcon: const Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.shopping_basket_outlined),
                selectedIcon: const Icon(Icons.shopping_basket),
                label: Text('Cart'),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.route_outlined),
                selectedIcon: const Icon(Icons.route),
                label: Text('Route'),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.place_outlined),
                selectedIcon: const Icon(Icons.place),
                label: Text('Map'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}
