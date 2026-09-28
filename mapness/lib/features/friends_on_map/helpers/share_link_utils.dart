import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/friends_on_map/models/share_mode.dart';
import 'package:mapness/features/friends_on_map/providers/share_watcher.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/share_arrival_card.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/share_watch_sheet.dart';
import 'package:mapness/features/path_nav/providers/path_nav_message.dart';
import 'package:mapness/features/routing/providers/current_route.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// S-19 (R-80/R-81) recipient-side deep-link dispatch — mirrors
/// `features/share_eta/helpers/utils.dart`'s `EtaUtils.processShareLink`
/// shape but simpler: no need to wait on the recipient's own GPS fix first
/// (only needed there to sensibly pan the camera before drawing a marker,
/// which S-19's watch doesn't require), and no old-engine single-slot
/// coupling to stop first (`ShareWatcher` is its own, independent
/// mechanism).
class ShareLinkUtils {
  static Future<bool> processShareLink(WidgetRef ref, {required String token, String? mode}) async {
    try {
      final shareMode = ShareMode.fromWire(mode ?? '');
      final appRouter = ref.read(appRouterProvider);
      // Mirrors EtaUtils.processShareLink's own 'live'-branch guard (fixed
      // for BSA-1010): navigating away from PathNavRoute below doesn't stop
      // native turn-by-turn navigation as a side effect — it would otherwise
      // keep running headless/orphaned in the background after this device
      // is redirected to view the arrival card.
      if (appRouter.isRouteActive(PathNavRoute.name)) {
        ref.read(pathNavMessageProvider.notifier).stopNavigation();
        await ref.read(dgisControllerProvider).value?.setMapAttributeBool('navigatorOn', value: false);
        unawaited(ref.read(dgisControllerProvider).value?.stopNavigation());
        ref.read(currentRouteProvider.notifier).clearRoute();
        unawaited(ref.read(dgisControllerProvider).value?.hideRoutes());
      }
      await appRouter.navigate(const LandingRoute());
      await ref.read(shareWatcherProvider.notifier).startWatching(token, mode: shareMode);
      final context = rootNavigatorKey.currentContext;
      if (context == null) {
        return true;
      }
      if (shareMode == ShareMode.eta) {
        showModalBottomSheet<void>(
          backgroundColor: Colors.transparent,
          context: context,
          isScrollControlled: true,
          builder: (_) => const ShareArrivalCard(),
        );
      } else {
        showShareWatchSheet(context);
      }
      return true;
    } catch (e) {
      logger.log('friends_on_map: share link processing failed: $e');
      return false;
    }
  }
}
