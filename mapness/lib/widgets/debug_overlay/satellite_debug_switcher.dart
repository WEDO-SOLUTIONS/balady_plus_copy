import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/satellite/providers/satellite_debug.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

class SatelliteDebugSwitcher extends ConsumerWidget {
  const SatelliteDebugSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = ref.watch(satelliteDebugOverrideProvider);
    final notifier = ref.read(satelliteDebugOverrideProvider.notifier);

    return DebugCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DebugSectionHeader(
            icon: Icons.satellite_alt_rounded,
            title: 'Satellite stand-in',
            subtitle: 'Bypass FRC; use ESRI World Imagery URL',
            gradient: DebugTheme.gradientTeal,
            trailing: DebugSwitch(
              value: isEnabled,
              onChanged: (value) {
                if (value) {
                  notifier.enable();
                } else {
                  notifier.disable();
                }
              },
              gradient: DebugTheme.gradientTeal,
            ),
          ),
        ],
      ),
    );
  }
}
