import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/app_icon_quick_actions/data/app_icon_quick_actions_config_datasource.dart';
import 'package:mapness/features/app_icon_quick_actions/models/app_icon_quick_action.dart';
import 'package:mapness/features/app_icon_quick_actions/providers/app_icon_quick_actions_config.dart';
import 'package:mapness/features/app_icon_quick_actions/providers/app_icon_quick_actions_manager.dart';
import 'package:mapness/features/app_icon_quick_actions/services/app_icon_quick_action_handler.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

/// Debug helpers to exercise app icon quick actions without long-pressing the launcher icon.
class AppIconQuickActionsDebugPanel extends ConsumerWidget {
  const AppIconQuickActionsDebugPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kDebugMode) {
      return const SizedBox.shrink();
    }

    final configAsync = ref.watch(appIconQuickActionsConfigProvider);

    return DebugCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DebugSectionHeader(
            icon: Icons.apps_rounded,
            title: 'App icon quick actions (BRD)',
            gradient: DebugTheme.gradientAmber,
          ),
          const SizedBox(height: 8),
          Text(
            'Simulate shortcut taps. On device, long-press the Balady+ icon on the home screen.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: DebugTheme.textSecondary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DebugButton(
                  label: 'Refresh config',
                  icon: Icons.cloud_sync_outlined,
                  gradient: DebugTheme.gradientTeal,
                  onPressed: () => ref.read(appIconQuickActionsManagerProvider.notifier).refresh(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          configAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('Config error: $error', style: const TextStyle(color: Colors.red)),
            data: (config) => FutureBuilder<AppIconQuickActionPlatform>(
              future: resolveCurrentAppIconQuickActionPlatform(),
              builder: (context, platformSnapshot) {
                if (!platformSnapshot.hasData) {
                  return const SizedBox.shrink();
                }
                final active = activeShortcutsForPlatform(config, platformSnapshot.data!);
                final inactive = config.shortcuts.where((s) => !s.status.isActive).toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (active.isNotEmpty) ...[
                      Text(
                        'Published (max ${maxPublishedShortcutsForPlatform(platformSnapshot.data!)})',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final item in active)
                            DebugButton(
                              label: item.key,
                              icon: Icons.touch_app_outlined,
                              onPressed: () => ref.read(appIconQuickActionHandlerProvider.notifier).handle(item.key),
                            ),
                        ],
                      ),
                    ],
                    if (inactive.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text('Inactive (should not appear on icon)', style: Theme.of(context).textTheme.labelSmall),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final item in inactive)
                            DebugButton(
                              label: item.key,
                              icon: Icons.block_outlined,
                              onPressed: () => ref.read(appIconQuickActionHandlerProvider.notifier).handle(item.key),
                            ),
                        ],
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
