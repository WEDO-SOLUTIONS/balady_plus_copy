import 'dart:async';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/app_icon_quick_actions/data/app_icon_quick_actions_config_datasource.dart';
import 'package:mapness/features/app_icon_quick_actions/data/app_icon_quick_actions_defaults.dart';
import 'package:mapness/features/app_icon_quick_actions/models/app_icon_quick_action.dart';
import 'package:mapness/features/app_icon_quick_actions/providers/pending_app_icon_quick_action.dart';
import 'package:mapness/features/app_icon_quick_actions/services/app_icon_quick_action_native_bridge.dart';
import 'package:mapness/features/app_icon_quick_actions/services/app_icon_quick_action_navigator.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/shared/ui/loading/loading_overlay.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_icon_quick_action_handler.g.dart';

@Riverpod(keepAlive: true)
class AppIconQuickActionHandler extends _$AppIconQuickActionHandler {
  String? _inFlightShortcutKey;
  Completer<void>? _inFlightCompleter;
  bool _deliveringColdStart = false;
  bool _deliveryRescheduleNeeded = false;

  @override
  void build() {}

  /// Plugin / home-screen tap entry point (warm vs cold start).
  Future<void> handleFromPlatform(String shortcutKey) async {
    if (_isRouterReady) {
      await handle(shortcutKey);
      return;
    }
    await queueShortcut(shortcutKey);
  }

  /// Queues a shortcut tap and delivers once the router is ready (BR#04).
  Future<void> queueShortcut(String shortcutKey, {bool isFirstRun = true}) async {
    logger.log('AppIconQuickActions: queue $shortcutKey');
    ref.read(pendingAppIconQuickActionProvider.notifier).setPending(shortcutKey, isFirstRun: isFirstRun);
    await deliverColdStartShortcut();
  }

  Future<void> handle(String shortcutKey, {bool isFirstRun = false}) async {
    if (_inFlightShortcutKey == shortcutKey && _inFlightCompleter != null) {
      logger.log('AppIconQuickActions: join in-flight handle($shortcutKey)');
      return _inFlightCompleter!.future;
    }

    _inFlightShortcutKey = shortcutKey;
    final inFlightCompleter = Completer<void>();
    _inFlightCompleter = inFlightCompleter;

    try {
      await _handleShortcut(shortcutKey, isFirstRun: isFirstRun);
    } finally {
      if (_inFlightShortcutKey == shortcutKey) {
        _inFlightShortcutKey = null;
        _inFlightCompleter = null;
      }
      if (!inFlightCompleter.isCompleted) {
        inFlightCompleter.complete();
      }
    }
  }

  Future<void> _handleShortcut(String shortcutKey, {bool isFirstRun = false}) async {
    logger.log('AppIconQuickActions: handle($shortcutKey, isFirstRun=$isFirstRun)');

    try {
      if (!await _waitForRouterReady()) {
        ref.read(pendingAppIconQuickActionProvider.notifier).setPending(shortcutKey, isFirstRun: isFirstRun);
        logger.log('AppIconQuickActions: router not ready, queued $shortcutKey');
        return;
      }

      final item = AppIconQuickActionsDefaults.findShortcut(shortcutKey);

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
    } finally {
      // Clear native storage so a stale launch intent cannot override later taps.
      await AppIconQuickActionNativeBridge.consumePendingShortcut();
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

  /// Ingests native shortcut storage and navigates once [rootNavigatorKey] is mounted.
  Future<void> deliverColdStartShortcut() async {
    if (_deliveringColdStart) {
      _deliveryRescheduleNeeded = true;
      return;
    }
    _deliveringColdStart = true;
    try {
      do {
        _deliveryRescheduleNeeded = false;
        await _ingestNativeShortcut();

        if (!await _waitForRouterReady()) {
          logger.log('AppIconQuickActions: router not ready, shortcut kept pending', logLevel: MapnessLogLevel.warning);
          return;
        }

        await processPending();
      } while (_deliveryRescheduleNeeded || ref.read(pendingAppIconQuickActionProvider.notifier).hasPending);
    } finally {
      _deliveringColdStart = false;
    }
  }

  Future<void> _ingestNativeShortcut() async {
    if (ref.read(pendingAppIconQuickActionProvider.notifier).hasPending) {
      return;
    }

    final nativeKey = await AppIconQuickActionNativeBridge.consumePendingShortcut();
    if (nativeKey != null && nativeKey.isNotEmpty) {
      logger.log('AppIconQuickActions: native consume $nativeKey');
      ref.read(pendingAppIconQuickActionProvider.notifier).setPending(nativeKey, isFirstRun: true);
    }
  }

  bool get _isRouterReady {
    final state = rootNavigatorKey.currentState;
    return state != null && state.mounted;
  }

  Future<bool> _waitForRouterReady() async {
    for (var attempt = 0; attempt < 300; attempt++) {
      if (_isRouterReady) {
        return true;
      }
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    logger.log('AppIconQuickActions: router not ready after timeout', logLevel: MapnessLogLevel.warning);
    return false;
  }

  /// BR#05 / BR#06 — login then continue to the selected destination.
  Future<bool> _ensureLoggedIn() async {
    await _runWithLoadingOverlay(CommonProperties.waitForAuthSessionReady);

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

  Future<void> _runWithLoadingOverlay(Future<void> Function() action) async {
    final context = rootNavigatorKey.currentContext;
    LoadingOverlayState? overlay;
    if (context != null && context.mounted) {
      try {
        overlay = LoadingOverlay.of(context)..startLoading();
      } catch (_) {
        // LoadingOverlay is not mounted yet.
      }
    }
    try {
      await action();
    } finally {
      overlay?.endLoading();
    }
  }

  String? _locationRouteOnCloseForShortcut(String shortcutKey) => switch (shortcutKey) {
    'directions' => RoutingPointsRoute.name,
    'share_my_location' || 'share_live_location' => ShareMyLocationRoute.name,
    _ => null,
  };

  /// BR#07 — request required device permissions before opening the journey.
  Future<bool> _ensurePermissions(AppIconQuickActionItem item, String shortcutKey) async {
    for (final permission in item.requirePermissions) {
      switch (permission) {
        case AppIconQuickActionPermission.location:
          final allowed = await ref
              .read(locationProvider.notifier)
              .checkLocationPermission(
                routeOnClose: _locationRouteOnCloseForShortcut(shortcutKey),
              );
          if (!allowed) {
            _track(shortcutKey: shortcutKey, outcome: 'permission_required', reason: 'location');
            final context = rootNavigatorKey.currentContext;
            if (context != null &&
                context.mounted &&
                !CommonFunctions.locationDialogShowed &&
                !ref.read(appRouterProvider).isPathActive('/request_location')) {
              ToastOverlay.of(context).show(
                title: AppLocalizations.of(context).appIconQuickActionUnavailable,
              );
            }
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

  /// BR#11 — fallback when the destination cannot be opened.
  Future<void> _showFallbackMessage() async {
    final context = rootNavigatorKey.currentContext;
    if (context == null || !context.mounted) {
      return;
    }
    ToastOverlay.of(context).show(
      title: AppLocalizations.of(context).appIconQuickActionUnavailable,
    );
  }

  /// BR#10 — analytics for selection, login, permission, open, and failure.
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
    detach(
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
      tag: 'appIconQuickActionHandler.track',
    );
  }
}
