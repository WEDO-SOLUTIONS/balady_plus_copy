import 'package:flutter/material.dart';
import 'package:mapness/features/tifo/tifo_tutorial_sheet.dart';
import 'package:mapness/features/tifo/tutorial/tifo_tutorial_demos.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';

/// The 13-step guided TIFO tutorial (Figma tutorial sequence). Two overlay
/// styles over demo content:
///  * bottom coach sheet — title + dots + paragraph + [back | Next];
///  * top tooltip card — paragraph + Previous / Next links.
///
/// Map steps have no background of their own: the route is transparent, so the
/// live map (with the TIFO layer on) stays visible behind the coach. Every
/// other step paints a canned demo replica — the tour never hits the backend.
class TifoGuidedTutorial extends StatefulWidget {
  const TifoGuidedTutorial({super.key});

  @override
  State<TifoGuidedTutorial> createState() => _TifoGuidedTutorialState();
}

/// Pushes the tour as a transparent fullscreen route. Resolves to `true` when
/// the player reaches the end ("Select team"), `false` on early exit.
Future<bool> showTifoGuidedTutorial(BuildContext context) async {
  final done = await Navigator.of(context).push<bool>(
    PageRouteBuilder<bool>(
      opaque: false,
      fullscreenDialog: true,
      transitionDuration: const Duration(milliseconds: 200),
      reverseTransitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (_, _, _) => const TifoGuidedTutorial(),
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
    this.nextLabel = 'Next',
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
  final String nextLabel;
}

class _TifoGuidedTutorialState extends State<TifoGuidedTutorial> {
  static final List<_TourStep> _steps = [
    const _TourStep(
      dot: 0,
      overlay: _OverlayKind.coachSheet,
      title: 'Control the Districts',
      text:
          'The city is divided into districts. Each district is controlled by the team that owns '
          'the most buildings inside it.',
    ),
    const _TourStep(
      dot: 0,
      bottomPanel: TifoDemoDistrictSheet(),
      text:
          'District overview: view the current owner, total buildings, and which teams control the '
          'district. Claim more buildings to help your team take over.',
    ),
    const _TourStep(
      dot: 1,
      overlay: _OverlayKind.coachSheet,
      title: 'Explore buildings',
      text: 'Every building can be claimed. Zoom in and tap any building to see its status and start a match.',
    ),
    const _TourStep(
      dot: 1,
      bottomPanel: TifoDemoBuildingSheet(state: TifoDemoBuildingState.unclaimed),
      text: "Buildings: unclaimed don't have an owner yet. Win the match to claim the building for your team.",
    ),
    const _TourStep(
      dot: 1,
      bottomPanel: TifoDemoBuildingSheet(state: TifoDemoBuildingState.owned),
      text:
          'Buildings: owned by another team have a score to beat. Score more goals than the current '
          'owner to claim the building.',
    ),
    // Penalty preview drives itself — START advances (rendered by the
    // overlay-none branch so it gets the tour callback).
    const _TourStep(dot: 2, overlay: _OverlayKind.none),
    const _TourStep(
      dot: 2,
      background: TifoDemoPenaltyHud(),
      text: 'Score goals by taking penalties. You get three misses.',
    ),
    const _TourStep(
      dot: 2,
      bottomPanel: TifoDemoBuildingSheet(state: TifoDemoBuildingState.claimed),
      text:
          "Congratulations! You've claimed this building for your team. Every claimed building brings "
          'your team closer to controlling the district.',
    ),
    const _TourStep(
      dot: 3,
      bottomPanel: TifoDemoLeaderboard(),
      text: 'See which teams control the city. Rankings are based on districts owned and total buildings claimed.',
    ),
    const _TourStep(
      dot: 3,
      background: TifoDemoProfile(),
      text: 'Track your team, tokens, completed trips, games played, and recent activity all in one place.',
    ),
    const _TourStep(
      dot: 3,
      background: TifoDemoProfile(),
      text: 'Tokens are used to start matches. Earn them by:\n•  Daily allowance\n•  Completing trips',
    ),
    const _TourStep(
      dot: 3,
      background: TifoDemoSupport(),
      overlay: _OverlayKind.coachSheet,
      title: 'Need help?',
      text: 'Visit support anytime to review the rules, penalty match mechanics, scoring.',
    ),
    const _TourStep(
      dot: 3,
      background: TifoDemoTeamSelect(),
      overlay: _OverlayKind.coachSheet,
      title: 'Choose your team',
      text: "Pick the team you'll represent this season. Your choice will remain locked until next season begins.",
      nextLabel: 'Select team',
    ),
  ];

  int _index = 0;

  _TourStep get _step => _steps[_index];

  bool get _isLast => _index == _steps.length - 1;

  void _next() {
    if (_isLast) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _index++);
    }
  }

  void _previous() {
    if (_index > 0) {
      setState(() => _index--);
    }
  }

  void _exit() => Navigator.of(context).pop(false);

  @override
  Widget build(BuildContext context) {
    final step = _step;
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
                nextLabel: step.nextLabel,
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
              ),
            ),
            _OverlayKind.none => Positioned.fill(
              // Preview step drives itself: START advances the tour.
              child: TifoDemoPenaltyPreview(onStart: _next),
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
    required this.nextLabel,
    required this.showBack,
    required this.onBack,
    required this.onNext,
    required this.onClose,
  });

  final String title;
  final String text;
  final int dot;
  final String nextLabel;
  final bool showBack;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      color: TifoColors.surface,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                decoration: BoxDecoration(color: TifoColors.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: Text(title, style: TifoText.h3)),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onClose,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(color: Color(0xFFF2F4F7), shape: BoxShape.circle),
                    child: const Icon(Icons.close_rounded, size: 18, color: TifoColors.textSoft),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TifoCoachDots(active: dot),
            const SizedBox(height: 18),
            Text(text, style: TifoText.bodyL.copyWith(height: 1.35)),
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
                        color: const Color(0xFFF2F4F7),
                        borderRadius: BorderRadius.circular(TifoRadii.l),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: TifoColors.textDefault),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: TifoPrimaryButton(label: nextLabel, trailingArrow: true, onPressed: onNext),
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
  });

  final String text;
  final bool showPrevious;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: TifoColors.surface,
        borderRadius: BorderRadius.circular(TifoRadii.l),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: TifoText.bodyL.copyWith(fontSize: 15, height: 1.35)),
          const SizedBox(height: 12),
          Row(
            children: [
              if (showPrevious) ...[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onPrevious,
                  child: Text('Previous', style: TifoText.bodyLSemi.copyWith(color: TifoColors.textSoft)),
                ),
                const SizedBox(width: 24),
              ],
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onNext,
                child: Text('Next', style: TifoText.bodyLSemi.copyWith(color: TifoColors.accent)),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
