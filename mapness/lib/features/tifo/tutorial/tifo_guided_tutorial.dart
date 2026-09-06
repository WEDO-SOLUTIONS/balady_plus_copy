import 'dart:async';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/tifo/tifo_flow_provider.dart';
import 'package:mapness/features/tifo/tutorial/tifo_spotlight.dart';
import 'package:mapness/features/tifo/tutorial/tifo_tutorial_demos.dart';
import 'package:mapness/features/tifo/ui/tifo_message_card.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

/// The guided TIFO tutorial, rebuilt against the Figma page "Tutorial"
/// (row "Tutorial - Confirmed ENG" and its dark twin).
///
/// Six screens in two alternating overlay styles:
///  * a **coach sheet** pinned to the bottom — dragger, title + close, the
///    progress pills, a paragraph, an optional graphic, then back + `Next`;
///  * a **tooltip card** pinned to the top — a paragraph plus `Cancel` /
///    `Previous` and `Next` text links.
///
/// Only the three coach sheets carry a progress pill; the tooltips between
/// them do not, which is why [TifoCoachDots.total] is 3 and not 6.
///
/// Steps that explain the map paint no background of their own: the route is
/// transparent, so the live map (with the TIFO layer on) stays visible behind
/// the overlay. The rest render a canned demo replica, so the tour never hits
/// the backend.
class TifoGuidedTutorial extends ConsumerStatefulWidget {
  const TifoGuidedTutorial({super.key, this.initialStep = 0});

  /// Index of the tour's closing screen — the "Need help?" sheet over Support.
  static const int lastStep = _TifoGuidedTutorialState._stepCount - 1;

  /// Which of the 6 tour screens to open on.
  final int initialStep;

  @override
  ConsumerState<TifoGuidedTutorial> createState() => _TifoGuidedTutorialState();
}

/// Pushes the tour as a transparent fullscreen route. Resolves to `true` only
/// when the player reaches the last screen — BRD V2 US-03 BR-06 treats an
/// abandoned tutorial as never started, and the journey gates on that.
///
/// [initialStep] opens the tour on a specific screen (e.g. the ball-menu "?"
/// control jumps straight to the closing support screen instead of replaying
/// the whole tour from screen 1).
Future<bool> showTifoGuidedTutorial(BuildContext context, {int initialStep = 0}) async {
  final done = await Navigator.of(context).push<bool>(
    PageRouteBuilder<bool>(
      opaque: false,
      fullscreenDialog: true,
      transitionDuration: const Duration(milliseconds: 200),
      reverseTransitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (_, _, _) => TifoGuidedTutorial(initialStep: initialStep),
      transitionsBuilder: (_, animation, _, child) => FadeTransition(opacity: animation, child: child),
    ),
  );
  return done ?? false;
}

enum _OverlayKind { coachSheet, tooltip }

class _TourStep {
  const _TourStep({
    required this.overlay,
    this.dot,
    this.background,
    this.bottomPanel,
    this.title,
    this.text,
    this.graphic,
  });

  /// Which progress pill is lit. Null on the tooltip steps — the design gives
  /// them no pills at all, so the row is hidden rather than dimmed.
  final int? dot;

  /// Fullscreen background; null → transparent (live map shows through).
  final Widget? background;

  /// Demo sheet pinned above the overlay controls (the standings replica).
  final Widget? bottomPanel;

  final _OverlayKind overlay;
  final String? title;
  final String? text;

  /// Optional artwork under the coach sheet's paragraph.
  final Widget? graphic;
}

class _TifoGuidedTutorialState extends ConsumerState<TifoGuidedTutorial> {
  /// Six screens: tooltip → sheet → tooltip → sheet → tooltip → sheet.
  static const int _stepCount = 6;

  List<_TourStep> _steps(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      // 1 — standings behind a top tooltip.
      _TourStep(
        overlay: _OverlayKind.tooltip,
        bottomPanel: const TifoDemoLeaderboard(),
        text: l10n.tifoTutorialPickTeam,
      ),
      // 2 — long-press coaching over the live map.
      _TourStep(
        overlay: _OverlayKind.coachSheet,
        dot: 0,
        title: l10n.tifoTutorialLongPressTitle,
        text: l10n.tifoTutorialLongPressBody,
        graphic: const _LongPressGraphic(),
      ),
      // 3 — penalty preview behind a top tooltip. The preview is scenery
      // here: the tour advances from the tooltip, so it gets no callbacks.
      _TourStep(
        overlay: _OverlayKind.tooltip,
        background: const IgnorePointer(child: TifoDemoPenaltyPreview()),
        text: l10n.tifoTutorialPenaltyHint,
      ),
      // 4 — token economy over the live map.
      _TourStep(
        overlay: _OverlayKind.coachSheet,
        dot: 1,
        title: l10n.tifoTutorialTokensTitle,
        text: l10n.tifoTutorialTokensBody,
        graphic: const _TokenFlowGraphic(),
      ),
      // 5 — the live dashboard dimmed down to the one control the tooltip
      // talks about, exactly as the design frames it.
      _TourStep(
        overlay: _OverlayKind.tooltip,
        background: TifoSpotlight(target: tifoHelpControlKey),
        text: l10n.tifoTutorialSupportHint,
      ),
      // 6 — support screen behind the closing coach sheet.
      _TourStep(
        overlay: _OverlayKind.coachSheet,
        dot: 2,
        background: TifoDemoSupport(onReplayTutorial: _replay, replayBusy: _replaying),
        title: l10n.needHelp,
        text: l10n.visitSupportAnytimeToReviewTheRulesPenaltyMatchMechanicsScoring,
      ),
    ];
  }

  late int _index = widget.initialStep.clamp(0, _stepCount - 1);

  /// True once the player has replayed the tour from the Support screen, so
  /// the device flag [resetTutorial] cleared is re-stamped when this run ends.
  bool _replayedFromSupport = false;

  /// Guards the async flag reset against a double tap on "Replay tutorial".
  bool _replaying = false;

  bool get _isLast => _index == _stepCount - 1;

  void _next() {
    if (_isLast) {
      unawaited(_finish(completed: true));
    } else {
      setState(() => _index++);
    }
  }

  /// Support → "Replay tutorial": clears the persisted "tutorial seen" flags
  /// and rewinds this route to screen 1, so the tour runs exactly as it does
  /// for a first-time player instead of resuming at the closing screen.
  Future<void> _replay() async {
    if (_replaying) {
      return;
    }
    setState(() => _replaying = true);
    try {
      await ref.read(tifoFlowProvider.notifier).resetTutorial();
    } finally {
      if (mounted) {
        setState(() {
          _replaying = false;
          _replayedFromSupport = true;
          _index = 0;
        });
      }
    }
  }

  /// Closes the route. After a replay the device flag has to come back before
  /// we leave (BR-02: the tour having been SHOWN clears the gate, finished or
  /// skipped) — otherwise the next play attempt, or a later sign-in that mints
  /// a fresh profile, would push the tour again unasked.
  Future<void> _finish({required bool completed}) async {
    if (_replayedFromSupport) {
      await ref.read(tifoFlowProvider.notifier).markTutorialCompletedOnDevice();
    }
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(completed);
  }

  void _previous() {
    if (_index > 0) {
      setState(() => _index--);
    }
  }

  /// The close control on either overlay is the tour's only exit — confirm
  /// first (Figma "Skip the tutorial" message state) since it reads as
  /// skipping the whole thing, not just closing an overlay.
  Future<void> _exit() async {
    final l10n = AppLocalizations.of(context);
    final skip = await showTifoMessageDialog<bool>(
      context,
      card: TifoMessageCard(
        title: l10n.tifoSkipTutorialTitle,
        body: l10n.tifoSkipTutorialBody,
        secondaryAction: TifoMessageAction(
          label: l10n.tifoContinue,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        onClose: () => Navigator.of(context).pop(false),
        primaryAction: TifoMessageAction(label: l10n.tifoSkip, onPressed: () => Navigator.of(context).pop(true)),
      ),
    );
    if (!mounted) return;
    if (skip ?? false) {
      await _finish(completed: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps(context)[_index];
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Swallow taps so the live map behind the transparent route stays
          // inert while the tour is up.
          const ModalBarrier(dismissible: false, color: Colors.transparent),
          if (step.background != null) step.background!,
          if (step.bottomPanel != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(reverse: true, child: step.bottomPanel),
            ),
          switch (step.overlay) {
            _OverlayKind.coachSheet => Align(
              alignment: Alignment.bottomCenter,
              child: _CoachSheet(
                title: step.title ?? '',
                text: step.text ?? '',
                dot: step.dot ?? 0,
                graphic: step.graphic,
                showBack: _index > 0,
                onBack: _previous,
                onNext: _next,
                onClose: _exit,
              ),
            ),
            _OverlayKind.tooltip => Align(
              alignment: Alignment.topCenter,
              child: _CoachTooltip(
                text: step.text ?? '',
                showPrevious: _index > 0,
                onPrevious: _previous,
                onNext: _next,
                onClose: _exit,
              ),
            ),
          },
        ],
      ),
    );
  }
}

/// Bottom coach sheet: dragger, title + close, pills, paragraph, optional
/// graphic, then back + `Next`.
///
/// The light body is the design's diagonal wash; dark is a flat
/// `backgroundSurface2`, which is also what the uikit uses for elevated
/// surfaces, so the sheet sits correctly against a dark map.
class _CoachSheet extends StatelessWidget {
  const _CoachSheet({
    required this.title,
    required this.text,
    required this.dot,
    required this.showBack,
    required this.onBack,
    required this.onNext,
    required this.onClose,
    this.graphic,
  });

  final String title;
  final String text;
  final int dot;
  final Widget? graphic;
  final bool showBack;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final dark = tifoIsDarkTheme(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: dark ? context.colors.backgroundSurface2 : null,
        gradient: dark
            ? null
            : const LinearGradient(
                // The Figma handles tilt the wash slightly off vertical.
                begin: Alignment(-0.36, -1),
                end: Alignment(0.36, 1),
                colors: [TifoTutorialTokens.sheetWashStart, TifoTutorialTokens.sheetWashEnd],
              ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(TifoTutorialTokens.sheetRadius)),
        boxShadow: const [TifoTutorialTokens.sheetShadow],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 12, bottom: 4),
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: TifoTutorialTokens.hairline,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TifoTutorialTokens.title.copyWith(color: context.colors.foregroundDefault),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _IconButtonBox(
                    size: 36,
                    onTap: onClose,
                    child: const Icon(Icons.close_rounded, size: 16, color: TifoTutorialTokens.closeStroke),
                  ),
                ],
              ),
            ),
            TifoCoachDots(active: dot),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      text,
                      style: TifoTutorialTokens.body.copyWith(color: context.colors.foregroundDefault),
                    ),
                  ),
                  if (graphic != null) ...[const SizedBox(height: 16), graphic!],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                children: [
                  if (showBack) ...[
                    _IconButtonBox(
                      size: 44,
                      // Dark flips the wash for a solid neutral, so the button
                      // stays visible on the near-black sheet.
                      color: dark ? context.colors.neutralMuted : null,
                      onTap: onBack,
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: TifoTutorialTokens.backStroke,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(child: _NextButton(onPressed: onNext)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Top tooltip card: a paragraph plus `Cancel` / `Previous` and `Next` links.
class _CoachTooltip extends StatelessWidget {
  const _CoachTooltip({
    required this.text,
    required this.showPrevious,
    required this.onPrevious,
    required this.onNext,
    required this.onClose,
  });

  final String text;
  final bool showPrevious;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final dark = tifoIsDarkTheme(context);
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      bottom: false,
      // 359 wide on the design's 393 board — 17 a side.
      child: Container(
        margin: const EdgeInsets.fromLTRB(17, 8, 17, 0),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          // `backgroundSurface1` is #FFFFFF in light but #111927 in dark,
          // where the design asks for #0D121C — hence the explicit pair.
          color: dark ? context.colors.backgroundSurface2 : context.colors.backgroundSurface1,
          borderRadius: BorderRadius.circular(TifoTutorialTokens.tooltipRadius),
          boxShadow: TifoTutorialTokens.tooltipShadow,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: TifoTutorialTokens.body.copyWith(color: context.colors.foregroundDefault),
                    ),
                    Row(
                      children: [
                        _TooltipLink(
                          // Screen 1 has nothing to go back to, so the design
                          // offers "Cancel" there and "Previous" afterwards.
                          label: showPrevious ? l10n.previous : l10n.cancel,
                          color: context.colors.foregroundSoft,
                          onTap: showPrevious ? onPrevious : onClose,
                        ),
                        const SizedBox(width: 24),
                        _TooltipLink(label: l10n.next, color: context.colors.accentDefault, onTap: onNext),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onClose,
                child: Icon(Icons.close_rounded, size: 24, color: context.colors.foregroundDefault),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A tooltip's text link. Sits in a 48-high hit box, as the design specifies.
class _TooltipLink extends StatelessWidget {
  const _TooltipLink({required this.label, required this.color, required this.onTap});

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onTap,
    child: SizedBox(
      height: 48,
      child: Center(
        child: Text(label, style: TifoTutorialTokens.link.copyWith(color: color)),
      ),
    ),
  );
}

/// The sheet's square glyph buttons — 36 for close, 44 for back.
class _IconButtonBox extends StatelessWidget {
  const _IconButtonBox({required this.size, required this.onTap, required this.child, this.color});

  final double size;
  final Color? color;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onTap,
    child: Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color ?? TifoTutorialTokens.buttonWash,
        borderRadius: BorderRadius.circular(TifoTutorialTokens.buttonRadius),
      ),
      child: child,
    ),
  );
}

/// The sheet's `Next` CTA. Shorter and squarer than [TifoPrimaryButton], and
/// without its green glow — the tutorial draws it as a plain 44/r14 pill.
class _NextButton extends StatelessWidget {
  const _NextButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
    color: context.colors.accentDefault,
    borderRadius: BorderRadius.circular(TifoTutorialTokens.buttonRadius),
    child: InkWell(
      borderRadius: BorderRadius.circular(TifoTutorialTokens.buttonRadius),
      onTap: onPressed,
      child: SizedBox(
        height: 44,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context).next, style: TifoTutorialTokens.cta),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white),
          ],
        ),
      ),
    ),
  );
}

/// Screen 2's artwork: a finger pressing and holding a building.
///
/// The only asset in the tour that the design draws twice: light fills the
/// hand white over a `#1B1B1B` outline, dark inverts it to a `#111927` fill
/// under a white one. The three token icons are byte-identical across themes,
/// so they are exported once.
class _LongPressGraphic extends StatelessWidget {
  const _LongPressGraphic();

  @override
  Widget build(BuildContext context) {
    final art = tifoIsDarkTheme(context) ? Assets.tifo.tutorial.longPressDark : Assets.tifo.tutorial.longPress;
    return Center(child: art.svg(width: 135, height: 128));
  }
}

/// Screen 4's artwork: the token loop — daily grant, then trips, then claims.
class _TokenFlowGraphic extends StatelessWidget {
  const _TokenFlowGraphic();

  static const double _tile = 48;
  static const double _icon = 28;
  static const double _arrow = 24;

  List<(AssetGenImage, String)> _steps(AppLocalizations l10n) => [
    (Assets.tifo.tutorial.tokenCar, l10n.tifoTutorialTokensStepDaily),
    (Assets.tifo.tutorial.tokenCoin, l10n.tifoTutorialTokensStepTrips),
    (Assets.tifo.tutorial.tokenBuilding, l10n.tifoTutorialTokensStepClaim),
  ];

  @override
  Widget build(BuildContext context) {
    final steps = _steps(AppLocalizations.of(context));
    final tile = tifoIsDarkTheme(context) ? TifoTutorialTokens.tileWashDark : TifoTutorialTokens.tileWash;
    return Row(
      // Tile and caption share one cell, so the caption is centred on its own
      // tile by construction. Laying them out as two independent rows — the
      // tiles inset, the captions full-width — drifts them out of line.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0)
            const Padding(
              // Centre the arrow on the tile, not on the whole cell.
              padding: EdgeInsets.only(top: (_tile - _arrow) / 2),
              child: Icon(Icons.arrow_forward_rounded, size: _arrow, color: TifoColors.textSoft),
            ),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: _tile,
                  height: _tile,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: tile,
                    borderRadius: BorderRadius.circular(TifoRadii.m),
                  ),
                  child: steps[i].$1.image(width: _icon, height: _icon),
                ),
                const SizedBox(height: 8),
                Text(
                  steps[i].$2,
                  textAlign: TextAlign.center,
                  style: TifoTutorialTokens.body.copyWith(color: context.colors.foregroundDefault),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
