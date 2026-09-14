import 'dart:async';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/tifo_flow_provider.dart';
import 'package:mapness/features/tifo/tifo_tutorial_sheet.dart';
import 'package:mapness/features/tifo/tutorial/tifo_tutorial_demos.dart';
import 'package:mapness/features/tifo/ui/tifo_message_card.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/utils/detach.dart';

/// The four-screen guided TIFO tutorial (Figma 848:9497, 848:9982, 848:10725,
/// 879:10224). Two overlay styles over demo content:
///  * bottom coach sheet — title + dots + paragraph + [back | Next];
///  * top tooltip card — paragraph + Previous / Next links.
///
/// Map steps have no background of their own: the route is transparent, so the
/// live map (with the TIFO layer on) stays visible behind the coach. Every
/// other step paints a canned demo replica — the tour never hits the backend.
class TifoGuidedTutorial extends ConsumerStatefulWidget {
  const TifoGuidedTutorial({super.key, this.initialStep = 0});

  /// Index of the tour's closing screen (879:10224, the support/"Need help" step).
  static const int lastStep = _TifoGuidedTutorialState._stepCount - 1;

  /// Which of the 4 tour screens to open on.
  final int initialStep;

  @override
  ConsumerState<TifoGuidedTutorial> createState() => _TifoGuidedTutorialState();
}

/// Pushes the tour as a transparent fullscreen route. Resolves to `true` only
/// when the player reaches the last screen — BRD V2 US-03 BR-06 treats an
/// abandoned tutorial as never started, and the journey gates on that.
///
/// [initialStep] opens the tour on a specific screen (e.g. the ⚽-⋮ "?"
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

enum _OverlayKind { coachSheet, tooltip, none }

class _TourStep {
  const _TourStep({
    required this.dot,
    this.background,
    this.bottomPanel,
    this.overlay = _OverlayKind.tooltip,
    this.title,
    this.text,
  });

  /// Which of the 4 progress dots is lit while on this step.
  final int dot;

  /// Fullscreen background; null → transparent (live map shows through).
  final Widget? background;

  /// Demo sheet pinned above the overlay controls (district/building/board).
  final Widget? bottomPanel;

  final _OverlayKind overlay;
  final String? title;
  final String? text;
}

class _TifoGuidedTutorialState extends ConsumerState<TifoGuidedTutorial> {
  /// Four screens, in the order design numbered them (Figma 848:9497,
  /// 848:9982, 848:10725, 879:10224) — down from the 13-step sequence that
  /// walked every sheet. The four progress dots finally match the step count.
  static const int _stepCount = 4;

  List<_TourStep> _steps(BuildContext context) => [
    // 1 — 848:9497: standings behind a top tooltip.
    _TourStep(
      dot: 0,
      bottomPanel: const TifoDemoLeaderboard(),
      text: AppLocalizations.of(context).tifoTutorialPickTeam,
    ),
    // 2 — 848:9982: the penalty preview drives itself, START advances
    // (rendered by the overlay-none branch so it gets the tour callback).
    const _TourStep(dot: 1, overlay: _OverlayKind.none),
    // 3 — 848:10725: intro sheet over the live map.
    _TourStep(
      dot: 2,
      overlay: _OverlayKind.coachSheet,
      title: AppLocalizations.of(context).tifoTutorialTitle,
      text: AppLocalizations.of(context).tifoTutorialIntro,
    ),
    // 4 — 879:10224: support screen behind the closing coach sheet.
    _TourStep(
      dot: 3,
      background: TifoDemoSupport(onReplayTutorial: _replay, replayBusy: _replaying),
      overlay: _OverlayKind.coachSheet,
      title: AppLocalizations.of(context).needHelp,
      text: AppLocalizations.of(context).visitSupportAnytimeToReviewTheRulesPenaltyMatchMechanicsScoring,
    ),
  ];

  late int _index = widget.initialStep.clamp(0, _stepCount - 1);

  /// True once the player has replayed the tour from the Support screen, so
  /// the device flag [resetTutorial] cleared is re-stamped when this run ends.
  bool _replayedFromSupport = false;

  /// Guards the async flag reset against a double tap on "Replay tutorial".
  bool _replaying = false;

  bool get _isLast => _index == _stepCount - 1;

  void _next() {
    if (_isLast) {
      detach(_finish(completed: true), tag: 'tifoGuidedTutorial.finish');
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

  /// The coach sheet's close `X` is the tour's only exit — confirm first
  /// (Figma "Skip the tutorial" message state) since it reads as skipping
  /// the whole thing, not just closing an overlay.
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
    if (!mounted) {
      return;
    }
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
                dot: step.dot,
                showBack: _index > 0,
                onBack: _previous,
                onNext: _next,
                onClose: _exit,
                bgColor: _index < 1 ? context.colors.backgroundSurface1 : context.colors.foregroundSurfacePush,
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
            _OverlayKind.none => Positioned.fill(
              // Preview step drives itself: START advances the tour, back
              // returns to the previous step (only when one exists).
              child: TifoDemoPenaltyPreview(
                onStart: _next,
                onBack: _index > 0 ? _previous : null,
                onClose: _exit,
              ),
            ),
          },
        ],
      ),
    );
  }
}

/// Bottom coach sheet: dragger, title + close, dots, paragraph, [back | Next].
class _CoachSheet extends StatelessWidget {
  const _CoachSheet({
    required this.title,
    required this.text,
    required this.dot,
    required this.showBack,
    required this.onBack,
    required this.onNext,
    required this.onClose,
    required this.bgColor,
  });

  final String title;
  final Color bgColor;
  final String text;
  final int dot;
  final bool showBack;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x40000000),
          offset: Offset(0, -12),
          blurRadius: 60,
        ),
      ],
    ),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colors.foregroundMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(title, style: TifoText.h3.copyWith(color: context.colors.foregroundDefault)),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onClose,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: context.colors.neutralContainerDefault,
                      borderRadius: BorderRadius.circular(TifoRadii.m),
                    ),
                    child: Icon(Icons.close_rounded, size: 18, color: context.colors.neutralOnContainer),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TifoCoachDots(active: dot),
            const SizedBox(height: 18),
            Text(text, style: TifoText.bodyL.copyWith(height: 1.35, color: context.colors.foregroundDefault)),
            const SizedBox(height: 22),
            Row(
              children: [
                if (showBack) ...[
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onBack,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: context.colors.neutralContainerDefault,
                        borderRadius: BorderRadius.circular(TifoRadii.l),
                      ),
                      child: Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: context.colors.neutralOnContainer),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: TifoPrimaryButton(
                    label: AppLocalizations.of(context).next,
                    trailingArrow: true,
                    onPressed: onNext,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// Top tooltip card: paragraph + Previous / Next text links.
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
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: context.colors.foregroundSurfacePush,
        borderRadius: BorderRadius.circular(TifoRadii.l),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  text,
                  style: TifoText.bodyL.copyWith(fontSize: 15, height: 1.35, color: context.colors.foregroundDefault),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onClose,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: context.colors.neutralContainerDefault,
                    borderRadius: BorderRadius.circular(TifoRadii.m),
                  ),
                  child: Icon(Icons.close_rounded, size: 18, color: context.colors.neutralOnContainer),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (showPrevious) ...[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onPrevious,
                  child: Text('Previous', style: TifoText.bodyLSemi.copyWith(color: context.colors.foregroundSoft)),
                ),
                const SizedBox(width: 24),
              ],
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onNext,
                child: Text(
                  AppLocalizations.of(context).next,
                  style: TifoText.bodyLSemi.copyWith(color: TifoColors.accent),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
