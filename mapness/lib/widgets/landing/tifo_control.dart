import 'dart:async';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/tifo/entry_screen.dart';
import 'package:mapness/features/tifo/leaderboard_sheet.dart';
import 'package:mapness/features/tifo/tifo_buildings_map_layer.dart';
import 'package:mapness/features/tifo/tifo_flow_provider.dart';
import 'package:mapness/features/tifo/tifo_journey.dart';
import 'package:mapness/features/tifo/tifo_surface.dart';
import 'package:mapness/features/tifo/tutorial/tifo_guided_tutorial.dart';
import 'package:mapness/features/tifo/tutorial/tifo_spotlight.dart';
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
        await journey.ensurePlayReady(journeyCtx, from: surface);
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
class TifoHelpControl extends ConsumerStatefulWidget {
  const TifoHelpControl({super.key});

  @override
  ConsumerState<TifoHelpControl> createState() => _TifoHelpControlState();
}

class _TifoHelpControlState extends ConsumerState<TifoHelpControl> with SingleTickerProviderStateMixin {
  /// Width of the label box inside the 48-wide button (Figma 1872:93850).
  /// Pinning it keeps the control square: `MapButton` only sets a *minimum*
  /// width, so an unconstrained label would stretch it past its neighbours.
  static const double _labelWidth = 41;

  /// One pass of the sheen across the button.
  static const Duration _sweepPeriod = Duration(milliseconds: 2600);

  /// Length of one repeat of the sheen, as a fraction of the button diagonal.
  /// The gradient tiles, so this is also the distance the pattern travels in a
  /// single cycle — which is what makes the loop seamless.
  static const double _tile = 0.6;

  late final AnimationController _sweep = AnimationController(vsync: this, duration: _sweepPeriod);

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  /// Runs the sheen only while it is actually wanted. A repeating controller
  /// schedules a frame forever, so it is stopped rather than left spinning
  /// behind a button that no longer shows a gradient.
  void _syncSweep({required bool animate}) {
    if (animate) {
      if (!_sweep.isAnimating) {
        unawaited(_sweep.repeat());
      }
    } else if (_sweep.isAnimating) {
      _sweep.stop();
    }
  }

  /// Diagonal green wash worn until the control's first tap, with a lighter
  /// band sliding along it.
  ///
  /// [phase] is the raw 0..1 controller value, and the last frame of a cycle
  /// is pixel-identical to the first: the gradient tiles with
  /// [TileMode.repeated], and one cycle slides it by exactly one tile, so the
  /// pattern lands back on itself. That is why the sweep runs at constant
  /// speed and forward only — easing it, or ping-ponging, would break the
  /// property this relies on.
  ///
  /// The tile is periodic for the same reason: it opens and closes on the same
  /// colour, so neighbouring tiles join with no seam. Only begin/end move;
  /// the stops stay put.
  LinearGradient _highlight(BuildContext context, double phase) {
    // Alignment spans -1..1 across the box, so one tile is `2 * _tile` wide
    // and a full cycle shifts the pattern by that much.
    final shift = -1 + 2 * _tile * phase;
    final span = 2 * _tile;
    return LinearGradient(
      begin: Alignment(shift, shift),
      end: Alignment(shift + span, shift + span),
      tileMode: TileMode.repeated,
      colors: _tileColors(context),
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
    );
  }

  /// The sheen's five-colour tile, taken from opposite ends of the accent ramp
  /// depending on the theme.
  ///
  /// The ramp is theme-independent in the DGA palette (`accentActive`
  /// #14573A, `accentDefault` #1B8354, `accentSoft` #25935F, `accentMuted`
  /// #54C08A), so the split has to be made here rather than left to the
  /// tokens. Each theme takes the end that its label can sit on: light runs
  /// the pale greens under `foregroundDefault`'s near-black ink, dark runs the
  /// deep ones under white.
  ///
  /// Both lists are a plateau with a seam: the middle three stops hold one
  /// colour and the ends hold the other, so what travels is the seam between
  /// tiles rather than a highlight sweeping over a ramp. That keeps most of
  /// the button at the contrast the label was chosen for, and it is why the
  /// pairs are only one step apart on the ramp — widening them dropped the
  /// label under 4.5:1 while the seam passed under it.
  List<Color> _tileColors(BuildContext context) {
    final colors = context.colors;
    return tifoIsDarkTheme(context)
        ? [colors.accentActive, colors.accentDefault, colors.accentDefault, colors.accentDefault, colors.accentActive]
        : [colors.accentSoft, colors.accentMuted, colors.accentMuted, colors.accentMuted, colors.accentSoft];
  }

  @override
  Widget build(BuildContext context) {
    // Until the control has been tapped once it wears the gradient, so a
    // first-time player notices the tour exists. While the persisted flag is
    // still loading, assume it HAS been tapped: that is the common case, and
    // guessing the other way would flash a highlight at returning players.
    final tapped = ref.watch(tifoTutorialControlTappedProvider).value ?? true;
    // Honour the platform's reduce-motion setting: the highlight still shows,
    // it just stops travelling.
    final still = MediaQuery.disableAnimationsOf(context);
    _syncSweep(animate: !tapped && !still);

    final label = AppLocalizations.of(context).gameTutorial;
    return AnimatedBuilder(
      animation: _sweep,
      builder: (context, _) => MapButton(
        // The tour's closing step dims the dashboard and cuts a window around
        // this button; the key is how [TifoSpotlight] finds where it landed.
        key: tifoHelpControlKey,
        semanticsLabel: label,
        gradient: tapped ? null : _highlight(context, still ? 0.5 : _sweep.value),
        onTap: () => unawaited(_open()),
        child: SizedBox(
          width: _labelWidth,
          child: Text(
            label,
            textAlign: TextAlign.center,
            // Two lines by design ("Game" / "Tutorial"); a longer translation
            // ellipsises rather than overflowing the map control.
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            // Design says #161616; `foregroundDefault` is #1B1B1B in light and
            // flips to white in dark, which the flat hex would not. The same
            // ink is used over the gradient, so the label follows the theme in
            // both states rather than pinning itself to on-accent white.
            style: TifoText.captionMedium.copyWith(color: context.colors.foregroundDefault),
          ),
        ),
      ),
    );
  }

  /// Stamps the "seen" flag before opening the tour, so the highlight is
  /// already gone when the player returns to the map — and stays gone across
  /// restarts, since the flag is persisted.
  Future<void> _open() async {
    await ref.read(tifoTutorialControlTappedProvider.notifier).markTapped();
    if (!mounted) {
      return;
    }
    await showTifoGuidedTutorial(context, initialStep: TifoGuidedTutorial.lastStep);
  }
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
            unawaited(TifoJourney(ref).ensurePlayReady(gateCtx));
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
