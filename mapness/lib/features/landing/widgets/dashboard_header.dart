import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/landing/dashboard.dart';
import 'package:mapness/features/landing/providers/dashboard_controls.dart';
import 'package:mapness/features/landing/widgets/favorites.dart';
import 'package:mapness/features/landing/widgets/search_bar.dart';

class DashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  DashboardHeaderDelegate({
    required this.dashboardKey,
    required this.dashboardState,
  });

  final GlobalKey<DashboardState> dashboardKey;
  final DashboardControlsState dashboardState;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return DashboardHeader(dashboardKey: dashboardKey);
  }

  @override
  double get maxExtent =>
      dashboardState == DashboardControlsState.idle ? 132 : 84;

  @override
  double get minExtent =>
      dashboardState == DashboardControlsState.idle ? 132 : 84;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({
    super.key,
    required this.dashboardKey,
  });

  final GlobalKey<DashboardState> dashboardKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardControlsProvider);

    return Container(
      color: dashboardState == DashboardControlsState.results
          ? const Color(0xFFF1F4F8)
          : Colors.white,
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Center(
            child: Container(
              height: 4,
              width: 26,
              decoration: const BoxDecoration(
                color: Color(0xFFDDE4EE),
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SearchBar(
              dashboardKey: dashboardKey,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          if (dashboardState == DashboardControlsState.idle) const Favorites(),
          if (dashboardState == DashboardControlsState.idle)
            const SizedBox(
              height: 16,
            ),
        ],
      ),
    );
  }
}
