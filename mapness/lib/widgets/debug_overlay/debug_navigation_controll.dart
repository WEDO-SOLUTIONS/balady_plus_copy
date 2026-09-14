import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/constants/navigation_constants.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

class DebugNavigationControll extends ConsumerWidget {
  const DebugNavigationControll({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(dgisControllerProvider);

    return DebugCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DebugSectionHeader(
            icon: Icons.navigation_rounded,
            title: 'Navigation Simulation',
            subtitle: 'Start simulated navigation',
            gradient: DebugTheme.gradientBlue,
          ),
          const SizedBox(height: 14),
          DebugButton(
            label: 'Start Simulation',
            icon: Icons.play_arrow_rounded,
            gradient: DebugTheme.gradientBlue,
            onPressed: () => controller.value?.startNavigationSimulation(
              NavigationConstants.navigationSpeedRangeZooms,
            ),
          ),
        ],
      ),
    );
  }
}
