import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/cityscape/cityscape_debug.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

class CityscapeDebugSwitcher extends ConsumerWidget {
  const CityscapeDebugSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = ref.watch(cityscapeDebugProvider);
    final notifier = ref.read(cityscapeDebugProvider.notifier);

    return DebugCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DebugSectionHeader(
            icon: Icons.location_city_rounded,
            title: 'Cityscape Debug',
            subtitle: 'Override feature to always return true',
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
