import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/founding_day/founding_day.dart';
import 'package:mapness/features/founding_day/founding_day_debug.dart';

class FoundingDayDebugSwitcher extends ConsumerWidget {
  const FoundingDayDebugSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = ref.watch(foundingDayUrbiProvider);
    final notifier = ref.read(foundingDayDebugUrbiProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Founding Day Debug', style: context.textStyles.h2SemiBold.copyWith(color: Colors.black)),
                Text(
                  'Override Founding Day feature to always return true',
                  style: context.textStyles.bodySmallMedium.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (value) {
              if (value) {
                notifier.enable();
              } else {
                notifier.disable();
              }
            },
            activeColor: Colors.green,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
