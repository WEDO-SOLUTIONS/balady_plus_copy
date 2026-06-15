import 'dart:async';

import 'package:mapness/features/app_icon_quick_actions/services/app_icon_quick_action_handler.dart';
import 'package:mapness/features/app_icon_quick_actions/services/app_icon_quick_actions_platform.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_icon_quick_actions_initializer.g.dart';

/// Binds shortcut delivery to [AppIconQuickActionHandler] as soon as [ProviderScope] mounts.
@Riverpod(keepAlive: true)
void appIconQuickActionsInitializer(Ref ref) {
  bindAppIconQuickActionsHandler((shortcutKey) {
    scheduleMicrotask(() {
      if (!ref.mounted) {
        return;
      }
      unawaited(ref.read(appIconQuickActionHandlerProvider.notifier).handleFromPlatform(shortcutKey));
    });
  });
}
