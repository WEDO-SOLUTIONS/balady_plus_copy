// TEMP-DEBUG-BE90-AUTONAV — remove before merge
//
// Throwaway scaffolding for verifying the BE-90 lock-screen Live Activity in the
// iOS simulator, where no UI taps are available. On dev/debug startup it
// automatically builds a car route across Riyadh and starts a SIMULATED
// navigation session (position moves along the route), then lets the existing
// entry_point navigationEvents listener open PathNavPage in "attach" mode.
//
// To disable without deleting: flip [_autoNav] to false.
// To remove: delete this file and the single hooked line in entry_point.dart
// (search for TEMP-DEBUG-BE90-AUTONAV).

import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/routing/providers/current_route.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/constants/navigation_constants.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Master switch for the auto-drive. Keep `true` only while testing BE-90.
const _autoNav = true;

/// Give the DGIS map SDK / landing page time to fully initialize.
const _startupDelay = Duration(seconds: 9);

/// Fallback start point — Riyadh center, matches the simulator's custom location.
const _fallbackStart = RouteParamsPoint(latitude: 24.7136, longitude: 46.6753);

/// Fixed drivable destination ~4.5 km northeast of the start.
const _destination = RouteParamsPoint(latitude: 24.7500, longitude: 46.7100);

/// Automatically starts simulated car navigation. Safe to call unconditionally
/// from the entry point: it no-ops outside debug builds and logs (never throws)
/// on any failure.
Future<void> debugAutoStartCarNavigation(WidgetRef ref) async {
  if (!_autoNav || !kDebugMode) {
    return;
  }

  try {
    await Future<void>.delayed(_startupDelay);
    final dgisController = await ref.read(dgisControllerProvider.future);

    // 1. Start point: the (simulated) device location if already known,
    //    otherwise the fixed Riyadh center. Poll briefly like the routing page
    //    effectively does via its location checks.
    var start = _fallbackStart;
    for (var i = 0; i < 10; i++) {
      final position = ref.read(locationProvider);
      if (position != null) {
        start = RouteParamsPoint(latitude: position.latitude, longitude: position.longitude);
        break;
      }
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }

    // 2. Build the car route exactly the way Routes.build does:
    //    setRouteParams + wait for routesInfoChangedEvents. This populates the
    //    native RouteEditor, whose selected route is what startNavigation /
    //    startNavigationSimulation consume.
    final routesCompleter = Completer<List<RouteInfo>>();
    final subscription = dgisController.routesInfoChangedEvents.listen((event) {
      if (!routesCompleter.isCompleted) {
        routesCompleter.complete(event.routes);
      }
    });
    await dgisController.hideRoutes();
    await dgisController.setRouteParams(
      RouteEditorRouteParamsMessage(
        startPoint: start.pointMessage,
        finishPoint: _destination.pointMessage,
        options: RouteSearchOptionsMessage.car,
      ),
    );
    final routes = await routesCompleter.future.timeout(const Duration(seconds: 20));
    await subscription.cancel();
    if (routes.isEmpty) {
      logger.log('TEMP-DEBUG-BE90-AUTONAV: route build returned no routes');
      return;
    }

    // 3. Mirror RoutingInfo._startNavigation's state bookkeeping so PathNavPage
    //    and the rest of the app see a normal navigation session.
    final points = [
      RouteParamsPointWithLabel(value: start, label: 'Debug start'),
      const RouteParamsPointWithLabel(value: _destination, label: 'Debug destination'),
    ];
    await ref
        .read(currentRouteProvider.notifier)
        .setNavigationState(
          CurrentRouteState(points: points, navType: RouteSearchOptionsMessage.car, route: routes.first),
        );
    ref.read(currentNavigationDestinationProvider.notifier).state = _destination;

    // 4. Drop any stale persisted navigator state so PathNavPage's
    //    restoreNavigationState() deterministically takes the
    //    "attach to already-active session" branch instead of restoring an old
    //    route with real GPS.
    await ref.read(sharedPrefsProvider).remove(MapnessConstants.navigatorStateKey);
    await ref.read(sharedPrefsProvider).remove(MapnessConstants.navigatorStateTypeKey);

    // 5. Start SIMULATED navigation — same call as the debug overlay's
    //    "Start Simulation" button. The native side starts the session with a
    //    simulated location source, so the position moves along the route.
    await dgisController.startNavigationSimulation(NavigationConstants.navigationSpeedRangeZooms);
    logger.log('TEMP-DEBUG-BE90-AUTONAV: simulated car navigation started');

    // 6. entry_point.listenNavigationEvents auto-pushes
    //    PathNavRoute(initAction: null) when it sees NavigationEvent.navigation
    //    outside the nav page (same mechanism as CarPlay-initiated navigation).
    //    Fallback: push it ourselves if that has not happened shortly after.
    await Future<void>.delayed(const Duration(seconds: 3));
    final appRouter = ref.read(appRouterProvider);
    final onNavPage = appRouter.currentSegments.any((segment) => segment.name == PathNavRoute.name);
    if (!onNavPage) {
      await appRouter.pushAndPopUntil(
        PathNavRoute(navType: RouteSearchOptionsMessage.car, initAction: null),
        predicate: (route) => route.settings.name == BottomMenuRoute.name,
      );
    }
  } catch (e, stackTrace) {
    logger.log('TEMP-DEBUG-BE90-AUTONAV failed: $e\n$stackTrace');
  }
}
