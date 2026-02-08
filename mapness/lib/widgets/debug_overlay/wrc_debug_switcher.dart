import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/wrc/wrc_debug.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

class WRCDebugSwitcher extends ConsumerWidget {
  const WRCDebugSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = ref.watch(wRCDebugProvider);
    final notifier = ref.read(wRCDebugProvider.notifier);

    return DebugCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DebugSectionHeader(
            icon: Icons.flag_rounded,
            title: 'WRC Debug',
            subtitle: 'Override feature to always return true',
            gradient: DebugTheme.gradientRed,
            trailing: DebugSwitch(
              value: isEnabled,
              onChanged: (value) {
                if (value) {
                  notifier.enable();
                } else {
                  notifier.disable();
                }
              },
              gradient: DebugTheme.gradientRed,
            ),
          ),
        ],
      ),
    );
  }
}
