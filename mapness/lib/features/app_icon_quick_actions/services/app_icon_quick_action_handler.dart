import 'dart:async';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/app_icon_quick_actions/data/app_icon_quick_actions_config_datasource.dart';
import 'package:mapness/features/app_icon_quick_actions/models/app_icon_quick_action.dart';
import 'package:mapness/features/app_icon_quick_actions/providers/app_icon_quick_actions_config.dart';
import 'package:mapness/features/app_icon_quick_actions/providers/pending_app_icon_quick_action.dart';
import 'package:mapness/features/app_icon_quick_actions/services/app_icon_quick_action_navigator.dart';
import 'package:mapness/features/share_eta/providers/share_my_location_launch_intent.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_icon_quick_action_handler.g.dart';

@Riverpod(keepAlive: true)
class AppIconQuickActionHandler extends _$AppIconQuickActionHandler {
  @override
  void build() {}

  Future<void> handle(String shortcutKey, {bool isFirstRun = false}) async {
    logger.log('AppIconQuickActions: handle($shortcutKey, isFirstRun=$isFirstRun)');

    if (!await _waitForRouterReady()) {
      ref.read(pendingAppIconQuickActionProvider.notifier).setPending(shortcutKey, isFirstRun: isFirstRun);
      logger.log('AppIconQuickActions: router not ready, queued $shortcutKey');
      return;
    }

    final config = await ref.read(appIconQuickActionsConfigProvider.future);
    final item = config.shortcuts.where((shortcut) => shortcut.key == shortcutKey).firstOrNull;

    if (item == null || !item.status.isActive) {
      _track(shortcutKey: shortcutKey, outcome: 'failure', reason: 'unknown_shortcut');
      await _showFallbackMessage();
      return;
    }

    final platform = await resolveCurrentAppIconQuickActionPlatform();
    if (!item.supportsPlatform(platform)) {
      _track(shortcutKey: shortcutKey, outcome: 'failure', reason: 'unsupported_platform');
      return;
    }

    final destination = Uri.tryParse(item.destination);
    if (destination == null || !isSupportedQuickActionDestination(destination)) {
      _track(shortcutKey: shortcutKey, outcome: 'failure', reason: 'invalid_destination');
      await _showFallbackMessage();
      return;
    }

    _track(shortcutKey: shortcutKey, outcome: 'selected');

    if (item.requireLogin && !ref.read(authMethodsProvider)) {
      _track(shortcutKey: shortcutKey, outcome: 'login_required');
      final loggedIn = await _ensureLoggedIn();
      if (!loggedIn) {
        logger.log('AppIconQuickActions: login cancelled or failed for $shortcutKey');
        return;
      }
    }

    if (!await _ensurePermissions(item, shortcutKey)) {
      return;
    }

    _prepareDestinationSideEffects(destination);

    try {
      await AppIconQuickActionNavigator(ref).open(
        destination: destination,
        isFirstRun: isFirstRun,
      );
      _track(shortcutKey: shortcutKey, outcome: 'opened');
    } catch (e, st) {
      logger.log('AppIconQuickActions: navigation failed: $e\n$st', logLevel: MapnessLogLevel.error);
      _track(shortcutKey: shortcutKey, outcome: 'failure', reason: e.toString());
      await _showFallbackMessage();
    }
  }

  Future<void> processPending() async {
    final pending = ref.read(pendingAppIconQuickActionProvider.notifier).take();
    if (pending == null) {
      return;
    }
    logger.log('AppIconQuickActions: processing pending ${pending.shortcutKey}');
    await handle(pending.shortcutKey, isFirstRun: pending.isFirstRun);
  }

  /// Waits until mapness [rootNavigatorKey] is mounted (cold start from home-screen shortcut).
  Future<bool> _waitForRouterReady() async {
    for (var attempt = 0; attempt < 60; attempt++) {
      final state = rootNavigatorKey.currentState;
      if (state != null && state.mounted) {
        return true;
      }
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    logger.log('AppIconQuickActions: router not ready after timeout', logLevel: MapnessLogLevel.warning);
    return false;
  }

  /// Shows login and waits for success — does not depend on a widget [BuildContext] staying mounted.
  Future<bool> _ensureLoggedIn() async {
    if (CommonProperties.isLoggedIn) {
      ref.read(authMethodsProvider.notifier).state = true;
      return true;
    }

    await ref.read(authProvider.notifier).doAuth();

    if (CommonProperties.isLoggedIn) {
      ref.read(authMethodsProvider.notifier).state = true;
      return true;
    }

    final completer = Completer<bool>();
    late final StreamSubscription<EntryPointState> subscription;
    subscription = CommonProperties.userStateStream.listen((event) {
      if (event.userInfo != null) {
        ref.read(authMethodsProvider.notifier).state = true;
        if (!completer.isCompleted) {
          completer.complete(true);
        }
        subscription.cancel();
      }
    });

    final loggedIn = await completer.future.timeout(
      const Duration(minutes: 5),
      onTimeout: () => false,
    );
    await subscription.cancel();
    return loggedIn;
  }

  void _prepareDestinationSideEffects(Uri destination) {
    final path = destination.fragment.isNotEmpty
        ? (Uri.tryParse(destination.fragment)?.path ?? destination.path)
        : destination.path;

    if (path == '/shareLiveLocation') {
      ref.read(shareMyLocationLaunchIntentProvider.notifier).requestLiveLocationOptions();
    }
  }

  Future<bool> _ensurePermissions(AppIconQuickActionItem item, String shortcutKey) async {
    for (final permission in item.requirePermissions) {
      switch (permission) {
        case AppIconQuickActionPermission.location:
          final allowed = await ref.read(locationProvider.notifier).checkLocationPermission();
          if (!allowed) {
            _track(shortcutKey: shortcutKey, outcome: 'permission_required', reason: 'location');
            return false;
          }
        case AppIconQuickActionPermission.camera:
          final status = await Permission.camera.request();
          if (!status.isGranted) {
            _track(shortcutKey: shortcutKey, outcome: 'permission_required', reason: 'camera');
            final context = rootNavigatorKey.currentContext;
            if (context != null && context.mounted) {
              ToastOverlay.of(context).show(
                title: AppLocalizations.of(context).accessCameraPermissionDesc,
              );
            }
            return false;
          }
      }
    }
    return true;
  }

  Future<void> _showFallbackMessage() async {
    final context = rootNavigatorKey.currentContext;
    if (context == null || !context.mounted) {
      return;
    }
    ToastOverlay.of(context).show(
      title: AppLocalizations.of(context).appIconQuickActionUnavailable,
    );
  }

  void _track({
    required String shortcutKey,
    required String outcome,
    String? reason,
  }) {
    logger.log('AppIconQuickActions: $shortcutKey → $outcome${reason != null ? ' ($reason)' : ''}');
    ref
        .read(appAnalyticsProvider)
        .appIconQuickActionSelected(
          action: shortcutKey,
          outcome: outcome,
          reason: reason,
        );
    unawaited(
      ref
          .read(urbiAnalyticsProvider)
          .track(
            'app_icon_quick_action',
            properties: {
              'shortcut_key': shortcutKey,
              'outcome': outcome,
              if (reason != null) 'reason': reason,
            },
          ),
    );
    Metrics.logEventAdvanced(
      MetricsConstants.appIconQuickActionsKeys.shortcutHandled,
      group: MetricsConstants.appIconQuickActionsTag,
      action: MetricAction.tap.name,
      props: {
        'shortcut_key': shortcutKey,
        'outcome': outcome,
        if (reason != null) 'reason': reason,
      },
    );
  }
}
