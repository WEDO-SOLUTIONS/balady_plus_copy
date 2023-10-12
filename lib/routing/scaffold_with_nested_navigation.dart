// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:balady_plus/utils/format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline,
                  size: 24,
                ),
                label: 'Profile',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.dashboard_outlined,
                  size: 24,
                ),
                label: 'Dashboard',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_basket_outlined,
                  size: 24,
                ),
                label: 'Cart',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.route,
                  size: 24,
                ),
                label: 'Route',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.place,
                  size: 24,
                ),
                label: 'Map',
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
                label: Text('Profile'.hardcoded),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.dashboard_outlined),
                selectedIcon: const Icon(Icons.dashboard),
                label: Text('Dashboard'.hardcoded),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.shopping_basket_outlined),
                selectedIcon: const Icon(Icons.shopping_basket),
                label: Text('Cart'.hardcoded),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.route_outlined),
                selectedIcon: const Icon(Icons.route),
                label: Text('Route'.hardcoded),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.place_outlined),
                selectedIcon: const Icon(Icons.place),
                label: Text('Map'.hardcoded),
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
