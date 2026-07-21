import 'dart:async';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/tifo/leaderboard_sheet.dart';
import 'package:mapness/features/tifo/tifo_buildings_map_layer.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

/// On-map control (⚽) that toggles the TIFO overlay — the production entry
/// point into the game, matching the Figma landing FAB. Tapping enables the
/// zoom-based TIFO layer (districts / buildings); browsing needs no login, so
/// the play-gate only kicks in later when a building is tapped. Auth is the
/// system SSO token (resolved in the API layer) — no manual config here.
class TifoControl extends ConsumerWidget {
  const TifoControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(tifoBuildingsMapLayerProvider);
    return MapButton(
      onTap: () {
        final layer = ref.read(tifoBuildingsMapLayerProvider.notifier);
        unawaited(enabled ? layer.disable() : layer.enable());
      },
      child: Icon(
        Icons.sports_soccer_rounded,
        size: 24,
        color: enabled ? context.colors.accentDefault : context.colors.foregroundDefault,
      ),
    );
  }
}

/// Trophy control (BT-05) — opens the Leaderboard/Dashboard sheet. Shown next
/// to [TifoControl] while the TIFO layer is on.
class TifoLeaderboardControl extends ConsumerWidget {
  const TifoLeaderboardControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MapButton(
    onTap: () {
      final ctx = rootNavigatorKey.currentContext;
      if (ctx != null) {
        unawaited(showTifoLeaderboardSheet(ctx));
      }
    },
    child: Icon(Icons.emoji_events_rounded, size: 24, color: context.colors.accentDefault),
  );
}
