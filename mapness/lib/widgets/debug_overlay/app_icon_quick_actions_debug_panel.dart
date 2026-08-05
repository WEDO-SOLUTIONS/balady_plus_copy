import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/app_icon_quick_actions/data/app_icon_quick_actions_config_datasource.dart';
import 'package:mapness/features/app_icon_quick_actions/models/app_icon_quick_action.dart';
import 'package:mapness/features/app_icon_quick_actions/providers/app_icon_quick_actions_config.dart';
import 'package:mapness/features/app_icon_quick_actions/providers/app_icon_quick_actions_manager.dart';
import 'package:mapness/features/app_icon_quick_actions/services/app_icon_quick_action_handler.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

/// Debug helpers to exercise BRD v0.2 static quick actions.
class AppIconQuickActionsDebugPanel extends ConsumerWidget {
  const AppIconQuickActionsDebugPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kDebugMode) {
      return const SizedBox.shrink();
    }

    final config = ref.watch(appIconQuickActionsConfigProvider);

    return DebugCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DebugSectionHeader(
            icon: Icons.apps_rounded,
            title: 'App icon quick actions (BRD v0.2)',
            gradient: DebugTheme.gradientAmber,
          ),
          const SizedBox(height: 8),
          Text(
            'Static predefined shortcuts. Long-press the Balady+ icon on the home screen.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: DebugTheme.textSecondary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DebugButton(
                  label: 'Resync labels',
                  icon: Icons.translate_outlined,
                  gradient: DebugTheme.gradientTeal,
                  onPressed: () => ref.read(appIconQuickActionsManagerProvider.notifier).syncPublishedShortcuts(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FutureBuilder<AppIconQuickActionPlatform>(
            future: resolveCurrentAppIconQuickActionPlatform(),
            builder: (context, platformSnapshot) {
              if (!platformSnapshot.hasData) {
                return const SizedBox.shrink();
              }
              final platform = platformSnapshot.data;
              if (platform == null) {
                return const SizedBox.shrink();
              }
              final shortcuts = activeShortcutsForPlatform(config, platform);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Predefined shortcuts (OS may show max ${maxPublishedShortcutsForPlatform(platform)})',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final item in shortcuts)
                        DebugButton(
                          label: item.key,
                          icon: Icons.touch_app_outlined,
                          onPressed: () => ref.read(appIconQuickActionHandlerProvider.notifier).handle(item.key),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
