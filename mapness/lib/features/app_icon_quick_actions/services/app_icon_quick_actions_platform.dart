import 'dart:async';
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

String? _lastDispatchedShortcutKey;
DateTime? _lastDispatchedAt;

bool _shouldIgnoreDuplicateDispatch(String shortcutKey) {
  final lastAt = _lastDispatchedAt;
  if (_lastDispatchedShortcutKey == shortcutKey &&
      lastAt != null &&
      DateTime.now().difference(lastAt) < const Duration(seconds: 3)) {
    return true;
  }
  _lastDispatchedShortcutKey = shortcutKey;
  _lastDispatchedAt = DateTime.now();
  return false;
}

void _dispatchShortcut(String shortcutKey) {
  if (_shortcutTapHandler != null && _shouldIgnoreDuplicateDispatch(shortcutKey)) {
    _logBridge('ignoring duplicate shortcut dispatch: $shortcutKey');
    return;
  }

  _logBridge('shortcut received: $shortcutKey');
  final handler = _shortcutTapHandler;
  if (handler != null) {
    _lastDispatchedShortcutKey = shortcutKey;
    _lastDispatchedAt = DateTime.now();
    handler(shortcutKey);
    return;
  }
  if (!_earlyPendingShortcutKeys.contains(shortcutKey)) {
    _earlyPendingShortcutKeys.add(shortcutKey);
    _lastDispatchedShortcutKey = shortcutKey;
    _lastDispatchedAt = DateTime.now();
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

  // Cold start: dispatch from native storage if the plugin callback was not ready in time.
  if (Platform.isAndroid || Platform.isIOS) {
    final nativeKey = await AppIconQuickActionNativeBridge.peekPendingShortcut();
    if (nativeKey != null && nativeKey.isNotEmpty) {
      _dispatchShortcut(nativeKey);
    }
  }

  _logBridge('bridge initialized');
}

/// Delivers a shortcut stored natively on warm start (onNewIntent / SceneDelegate).
/// The [quick_actions] plugin callback is unreliable when a custom SceneDelegate or
/// pre-warmed engine is used, so we poll our native channel on resume.
Future<void> deliverNativeShortcutIfPresent() async {
  if (!Platform.isAndroid && !Platform.isIOS) {
    return;
  }
  final nativeKey = await AppIconQuickActionNativeBridge.peekPendingShortcut();
  if (nativeKey == null || nativeKey.isEmpty) {
    return;
  }
  _logBridge('native shortcut pending: $nativeKey');
  _dispatchShortcut(nativeKey);
}

/// Reads shortcut key stored in native launch intent (pre-warmed engine safe).
Future<String?> pollAppIconQuickActionLaunch() async {
  if (!Platform.isAndroid && !Platform.isIOS) {
    return null;
  }
  final nativeKey = await AppIconQuickActionNativeBridge.consumePendingShortcut();
  if (nativeKey != null && nativeKey.isNotEmpty) {
    _logBridge('native cold-start shortcut: $nativeKey');
    return nativeKey;
  }
  return null;
}

/// Wires Riverpod handler and flushes shortcuts received before [ProviderScope] mounted.
void bindAppIconQuickActionsHandler(AppIconQuickActionTapHandler handler) {
  _shortcutTapHandler = handler;
  if (_earlyPendingShortcutKeys.isEmpty) {
    return;
  }
  final pending = List<String>.from(_earlyPendingShortcutKeys);
  _earlyPendingShortcutKeys.clear();
  scheduleMicrotask(() {
    for (final shortcutKey in pending) {
      _logBridge('flushing queued shortcut: $shortcutKey');
      handler(shortcutKey);
    }
  });
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

    final systemLanguage = Language.fromSystemLocale();
    final shortcutItems = activeItems.map((item) {
      final icon = resolveNativeQuickActionIcon(item.iconReference);
      return ShortcutItem(
        type: item.key,
        localizedTitle: systemLanguage == Language.arabic ? item.labelAr : item.labelEn,
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
