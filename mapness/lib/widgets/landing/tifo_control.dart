import 'dart:async';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
// `show`: `tifo_events.dart` also declares a `TifoSurface`, and this file uses
// the visible-route snapshot of that name from `tifo_surface.dart`.
import 'package:mapness/features/balady_analytics/events/tifo_events.dart'
    show TifoActivationSource, TifoEntryAction, TifoEvents;
import 'package:mapness/features/tifo/entry_screen.dart';
import 'package:mapness/features/tifo/leaderboard_sheet.dart';
import 'package:mapness/features/tifo/tifo_buildings_map_layer.dart';
import 'package:mapness/features/tifo/tifo_flow_provider.dart';
import 'package:mapness/features/tifo/tifo_journey.dart';
import 'package:mapness/features/tifo/tifo_surface.dart';
import 'package:mapness/features/tifo/tutorial/tifo_guided_tutorial.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
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
      child: const TifoBallIcon(),
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
    // Anchor the whole flow to the surface this tap happened on: the entry
    // popup and the layer toggle below are both awaited, and the player can
    // switch tabs meanwhile — the gate screens must not follow them there.
    final surface = TifoSurface.capture(ref);
    final layer = ref.read(tifoBuildingsMapLayerProvider.notifier);
    if (enabled) {
      await layer.disable();
      return;
    }
    // First entry this session shows the stories-style intro (Figma
    // node 286:20818). Pushed on the root navigator — the control's own
    // context may sit outside it.
    final flow = ref.read(tifoFlowProvider.notifier);
    final journey = TifoJourney(ref);
    var proceed = false;
    if (!ref.read(tifoFlowProvider).hasSeenEntry) {
      final entryCtx = rootNavigatorKey.currentContext ?? context;
      // The CTA carries the play-gate's network prep under its own spinner,
      // and the layer turns on underneath the popup — so by the time the
      // player is back on the map the next gate screen is already going up.
      // Both used to run AFTER the popup closed, which is the gap the player
      // slipped through into another tab.
      final entry = showTifoEntry(entryCtx, onEnter: journey.prepare);
      // FR-01: the ⚽ is the overlay toggle — the tap turns the layer on no
      // matter how the intro was dismissed (Close(X) → Landing WITH the
      // overlay the user just switched on; the popup gates only the journey).
      // A bridge failure here must not swallow the popup's result: the entry
      // future is already in flight and nothing else would await it.
      try {
        await layer.enable();
      } catch (e) {
        logger.log('[tifo] layer enable failed under the entry popup: $e');
      }
      proceed = await entry;
      logger.log('[tifo] entry popup result: $proceed');
      // Once per app run — the `hasSeenEntry` gate above is what shows this
      // popup at most once, so the event inherits that cap.
      TifoEvents.entryOutcome(action: proceed ? TifoEntryAction.cta : TifoEntryAction.close);
      flow.markEntrySeen();
    } else {
      await layer.enable();
    }
    // BRD V2: the entry CTA routes to the first unmet gate (tutorial →
    // team selected, login at team confirmation — US-01 BR-01); an
    // onboarded player just lands on the map. The journey owns every gate
    // screen, including the tutorial autorun — no separate offer here.
    if (proceed) {
      final journeyCtx = rootNavigatorKey.currentContext;
      if (journeyCtx != null) {
        await journey.ensurePlayReady(journeyCtx, source: TifoActivationSource.banner, from: surface);
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
        child: const TifoBallIcon(),
      ),
    ),
  );
}

/// Trophy control (BT-05) — opens the Leaderboard/Dashboard sheet. Shown next
/// to [TifoControl] while the TIFO layer is on.
///
/// Rapid-double-tap protection lives in [showTifoLeaderboardSheet] itself,
/// not here: this button mounts inside a conditional list in
/// `MapDashboardControls`, so a sibling rebuild can recreate its Element
/// (and any State it held) between two fast taps.
class TifoLeaderboardControl extends StatelessWidget {
  const TifoLeaderboardControl({super.key});

  @override
  Widget build(BuildContext context) => MapButton(
    onTap: () {
      final ctx = rootNavigatorKey.currentContext;
      if (ctx == null) {
        return;
      }
      unawaited(showTifoLeaderboardSheet(ctx));
    },
    child: Icon(Icons.emoji_events_rounded, size: 24, color: context.colors.accentDefault),
  );
}

/// "?" help control (design 879:10224) — opens the guided tutorial directly,
/// same tour the play-gate autoruns for a first-time player
/// ([TifoJourney.ensurePlayReady]). Shown only while the TIFO layer is on: a
/// disabled game has no rules screen to explain.
class TifoHelpControl extends StatelessWidget {
  const TifoHelpControl({super.key});

  @override
  Widget build(BuildContext context) => MapButton(
    onTap: () => unawaited(showTifoGuidedTutorial(context, initialStep: TifoGuidedTutorial.lastStep)),
    child: Assets.imagesSvg.tifoHelp.svg(
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(context.colors.foregroundDefault, BlendMode.srcIn),
    ),
  );
}

/// Floating "Dominate with your team →" pill over the map while the TIFO layer
/// is on (design node 589:85824 "Join Tifo"). Tapping walks the play-gate
/// (login → tutorial → team select).
class TifoJoinPill extends ConsumerWidget {
  const TifoJoinPill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Directionality(
    // `MapDashboardControls` pins its whole lower band to LTR so the map
    // buttons keep their fixed on-screen sides, and only restores the app
    // direction around the header. This pill is text, not a map button — it
    // has to read in the app's language direction, so it opts back in the
    // same way `MapHiddenStateControls` and the sheets do.
    textDirection: ref.watch(uiDirectionProvider),
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x4D16A34A), offset: Offset(0, 4), blurRadius: 10)],
      ),
      child: Material(
        color: TifoColors.accent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          // Gate screens go on the ROOT navigator: from this pill's own
          // context `Navigator.of` resolves to the landing tab's nested
          // router, so the guided tutorial and team-select were pushed
          // INSIDE the tab instead of over the app — same reason the
          // leaderboard CTA reaches for `rootNavigatorKey`.
          onTap: () {
            final gateCtx = rootNavigatorKey.currentContext;
            if (gateCtx == null) {
              return;
            }
            unawaited(TifoJourney(ref).ensurePlayReady(gateCtx, source: TifoActivationSource.mapPill));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    AppLocalizations.of(context).dominateWithYourTeam,
                    // The type ramp deliberately carries no font of its own: it
                    // inherits the ThemeData swap between Golos (en) and IBM
                    // Plex Sans Arabic (ar) — see [TifoText]. This pill used to
                    // pin "Golos" inline, which is Latin-only, so the Arabic
                    // label fell back to whatever face the system offered.
                    style: TifoText.bodyLSemi.copyWith(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                // Directional by design: `arrow_forward_rounded` carries
                // `matchTextDirection`, so it points left in Arabic, and the Row
                // reorders itself under the RTL scope above.
                const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
