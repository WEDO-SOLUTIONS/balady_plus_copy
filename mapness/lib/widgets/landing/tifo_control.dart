import 'dart:async';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/tifo/entry_screen.dart';
import 'package:mapness/features/tifo/leaderboard_sheet.dart';
import 'package:mapness/features/tifo/tifo_buildings_map_layer.dart';
import 'package:mapness/features/tifo/tifo_flow_provider.dart';
import 'package:mapness/features/tifo/tifo_journey.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// On-map control (⚽) that toggles the TIFO overlay — the production entry
/// point into the game, matching the Figma landing FAB ("Activate Tifo",
/// node 589:85528). First tap per session shows the stories entry-popup; its
/// CTA routes to the first unmet onboarding gate (tutorial → team, login at
/// team confirmation — BRD V2 US-01 BR-01) via [TifoJourney]. Active state
/// is a filled green button.
/// Auth is the system SSO token (resolved in the API layer) — no manual
/// config here.
class TifoControl extends ConsumerWidget {
  const TifoControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(tifoBuildingsMapLayerProvider);
    if (enabled) {
      // Active: green fill + white ball (design's toggled state). Same
      // geometry/shadow as [MapButton] so the controls column stays uniform.
      return _ActiveTifoButton(onTap: () => _guardedTap(context, ref, enabled: true));
    }
    return MapButton(
      onTap: () => _guardedTap(context, ref, enabled: false),
      child: const TifoBallIcon(size: 24),
    );
  }

  /// Fire-and-forget with explicit logging — a silent async throw here reads
  /// as "the button does nothing" on device.
  void _guardedTap(BuildContext context, WidgetRef ref, {required bool enabled}) {
    unawaited(
      _onTap(context, ref, enabled: enabled).catchError((Object e, StackTrace st) {
        logger.log('[tifo] ⚽ tap failed: $e\n$st');
      }),
    );
  }

  Future<void> _onTap(BuildContext context, WidgetRef ref, {required bool enabled}) async {
    logger.log('[tifo] ⚽ tap: enabled=$enabled');
    final layer = ref.read(tifoBuildingsMapLayerProvider.notifier);
    if (enabled) {
      await layer.disable();
      return;
    }
    // First entry this session shows the stories-style intro (Figma
    // node 286:20818). Pushed on the root navigator — the control's own
    // context may sit outside it.
    final flow = ref.read(tifoFlowProvider.notifier);
    var proceed = false;
    if (!ref.read(tifoFlowProvider).hasSeenEntry) {
      final entryCtx = rootNavigatorKey.currentContext ?? context;
      proceed = await showTifoEntry(entryCtx);
      logger.log('[tifo] entry popup result: $proceed');
      flow.markEntrySeen();
    }
    // FR-01: the ⚽ is the overlay toggle — the tap turns the layer on no
    // matter how the intro was dismissed (Close(X) → Landing WITH the
    // overlay the user just switched on; the popup gates only the journey).
    await layer.enable();
    // Very first launch ever → show the floating "Dominate" pill this session.
    await flow.markGameLaunched();
    // BRD V2: the entry CTA routes to the first unmet gate (tutorial →
    // team selected, login at team confirmation — US-01 BR-01); an
    // onboarded player just lands on the map. The journey owns every gate
    // screen, including the tutorial autorun — no separate offer here.
    if (proceed) {
      final journeyCtx = rootNavigatorKey.currentContext;
      if (journeyCtx != null) {
        await TifoJourney(ref).ensurePlayReady(journeyCtx);
      }
    }
  }
}

class _ActiveTifoButton extends StatelessWidget {
  const _ActiveTifoButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Container(
    width: MapButton.defaultSize,
    height: MapButton.defaultSize,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 1),
        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
      ],
    ),
    child: Material(
      color: TifoColors.accent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: const TifoBallIcon(size: 24),
      ),
    ),
  );
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

/// Floating "Dominate with your team →" pill over the map while the TIFO layer
/// is on (design node 589:85824 "Join Tifo"). Tapping walks the play-gate
/// (login → tutorial → team select).
class TifoJoinPill extends ConsumerWidget {
  const TifoJoinPill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [BoxShadow(color: Color(0x4D16A34A), offset: Offset(0, 4), blurRadius: 10)],
    ),
    child: Material(
      color: TifoColors.accent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => unawaited(TifoJourney(ref).ensurePlayReady(context)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Dominate with your team',
                style: TextStyle(
                  fontFamily: 'Golos',
                  package: 'balady_uikit',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
            ],
          ),
        ),
      ),
    ),
  );
}
