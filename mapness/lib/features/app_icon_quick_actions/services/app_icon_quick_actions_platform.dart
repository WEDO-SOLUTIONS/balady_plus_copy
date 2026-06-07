import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mapness/features/app_icon_quick_actions/data/app_icon_quick_actions_config_datasource.dart';
import 'package:mapness/features/app_icon_quick_actions/models/app_icon_quick_action.dart';
import 'package:mapness/features/app_icon_quick_actions/services/app_icon_quick_action_native_bridge.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:quick_actions/quick_actions.dart';

/// Shared plugin instance – initialize() and setShortcutItems() must use the same object.
const appQuickActions = QuickActions();

typedef AppIconQuickActionTapHandler = void Function(String shortcutKey);

final List<String> _earlyPendingShortcutKeys = <String>[];
AppIconQuickActionTapHandler? _shortcutTapHandler;
bool _bridgeInitialized = false;

void _dispatchShortcut(String shortcutKey) {
  _logBridge('shortcut received: $shortcutKey');
  final handler = _shortcutTapHandler;
  if (handler != null) {
    handler(shortcutKey);
    return;
  }
  if (!_earlyPendingShortcutKeys.contains(shortcutKey)) {
    _earlyPendingShortcutKeys.add(shortcutKey);
  }
  _logBridge('queued shortcut (handler not bound yet): $shortcutKey');
}

/// Call after [HostFlutterApi.runMain] — Activity exists and Android [getLaunchAction] works.
Future<void> initAppIconQuickActionsBridge() async {
  if (_bridgeInitialized) {
    return;
  }
  _bridgeInitialized = true;

  try {
    await appQuickActions.initialize(_dispatchShortcut);
  } catch (e, st) {
    _logBridge('plugin initialize failed (native bridge still active): $e\n$st');
  }

  await pollAppIconQuickActionLaunch();
  _logBridge('bridge initialized');
}

/// Reads shortcut key stored in native launch intent (pre-warmed engine safe).
Future<void> pollAppIconQuickActionLaunch() async {
  final nativeKey = await AppIconQuickActionNativeBridge.consumePendingShortcut();
  if (nativeKey != null && nativeKey.isNotEmpty) {
    _dispatchShortcut(nativeKey);
  }
}

/// Wires Riverpod handler and flushes shortcuts received before [ProviderScope] mounted.
void bindAppIconQuickActionsHandler(AppIconQuickActionTapHandler handler) {
  _shortcutTapHandler = handler;
  if (_earlyPendingShortcutKeys.isEmpty) {
    return;
  }
  final pending = List<String>.from(_earlyPendingShortcutKeys);
  _earlyPendingShortcutKeys.clear();
  for (final shortcutKey in pending) {
    _logBridge('flushing queued shortcut: $shortcutKey');
    handler(shortcutKey);
  }
}

void _logBridge(String message) {
  if (kDebugMode) {
    debugPrint('AppIconQuickActions: $message');
  }
  try {
    logger.log('AppIconQuickActions: $message');
  } catch (_) {
    // Logger may not be ready during [runMapnessApp].
  }
}

class AppIconQuickActionsPlatformService {
  const AppIconQuickActionsPlatformService(this._quickActions);

  final QuickActions _quickActions;

  Future<void> syncShortcuts({
    required AppIconQuickActionsConfig config,
    required Language language,
    required AppIconQuickActionPlatform platform,
  }) async {
    if (!_isPlatformSupported()) {
      await _quickActions.clearShortcutItems();
      return;
    }

    final activeItems = activeShortcutsForPlatform(config, platform);

    if (activeItems.isEmpty) {
      logger.log(
        'AppIconQuickActions: no active shortcuts to publish (platform=${platform.name})',
        logLevel: MapnessLogLevel.warning,
      );
      await _quickActions.clearShortcutItems();
      return;
    }

    final shortcutItems = activeItems.map((item) {
      final icon = resolveNativeQuickActionIcon(item.iconReference);
      return ShortcutItem(
        type: item.key,
        localizedTitle: language == Language.arabic ? item.labelAr : item.labelEn,
        icon: icon.isEmpty ? null : icon,
      );
    }).toList();

    try {
      await _quickActions.setShortcutItems(shortcutItems);
      logger.log(
        'AppIconQuickActions: published ${shortcutItems.length} shortcuts: ${shortcutItems.map((e) => e.type).join(', ')}',
      );
    } catch (e, st) {
      logger.log(
        'AppIconQuickActions: setShortcutItems failed: $e\n$st',
        logLevel: MapnessLogLevel.error,
      );
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  bool _isPlatformSupported() => Platform.isIOS || Platform.isAndroid;
}
