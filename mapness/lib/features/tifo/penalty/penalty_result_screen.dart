import 'package:flutter/material.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';

/// Fullscreen post-penalty result (BRD US-14) — one hero per outcome:
///   * win  (claimed/taken) — trophy celebration, fireworks;
///   * loss (failed)        — hands on head in the rain;
///   * neutral (voided/unknown) — hands on hips, quiet stadium.
///
/// The scoreline is rendered INSIDE the stadium scoreboard baked into each
/// background: image + score live in one image-pixel coordinate space that a
/// cover-fit [FittedBox] scales as a whole, so the digits stay glued to the
/// board on any screen size.
class TifoPenaltyResultScreen extends StatelessWidget {
  const TifoPenaltyResultScreen({required this.result, required this.scoreToBeat, super.key});

  final TifoPlayResult result;

  /// The defending score of the building — right side of the scoreline.
  final int scoreToBeat;

  static const _bg = Color(0xFF0A0F0B);

  /// Per-variant art metadata: natural size of the sliced panel and the
  /// scoreboard rectangle in image-fraction coordinates (measured off the art).
  ({String asset, Size size, Rect board, String title, String message, Color scoreColor}) get _content =>
      switch (result.outcome) {
        TifoOutcome.claimed => (
          asset: 'result_win.jpg',
          size: const Size(484, 1007),
          board: const Rect.fromLTRB(0.32, 0.320, 0.67, 0.385),
          title: 'VICTORY!',
          message: 'You claimed this building for your team!',
          scoreColor: const Color(0xFF6FE29B),
        ),
        TifoOutcome.taken => (
          asset: 'result_win.jpg',
          size: const Size(484, 1007),
          board: const Rect.fromLTRB(0.32, 0.320, 0.67, 0.385),
          title: 'VICTORY!',
          message: 'You took the building from the rival club!',
          scoreColor: const Color(0xFF6FE29B),
        ),
        // A tie is its own mood (the middle panel): matched the score but the
        // building holds.
        TifoOutcome.failed when result.yourScore == scoreToBeat => (
          asset: 'result_draw.jpg',
          size: const Size(485, 1007),
          board: const Rect.fromLTRB(0.34, 0.320, 0.69, 0.395),
          title: 'A DRAW',
          message: 'You matched the score — the building holds. One more goal next time.',
          scoreColor: const Color(0xFFFFC24D),
        ),
        TifoOutcome.failed => (
          asset: 'result_loss.jpg',
          size: const Size(490, 1007),
          board: const Rect.fromLTRB(0.31, 0.320, 0.69, 0.400),
          title: 'NOT THIS TIME',
          message: 'The building holds. Train up and come back.',
          scoreColor: const Color(0xFFF64B3C),
        ),
        TifoOutcome.voided => (
          asset: 'result_draw.jpg',
          size: const Size(485, 1007),
          board: const Rect.fromLTRB(0.34, 0.320, 0.69, 0.395),
          title: 'SESSION VOIDED',
          message: 'This session did not count. Try again.',
          scoreColor: const Color(0xFFFFC24D),
        ),
        TifoOutcome.unknown => (
          asset: 'result_draw.jpg',
          size: const Size(485, 1007),
          board: const Rect.fromLTRB(0.34, 0.320, 0.69, 0.395),
          title: 'CHALLENGE COMPLETE',
          message: 'Result is being processed.',
          scoreColor: const Color(0xFFFFC24D),
        ),
      };

  bool get _isWin => result.isWin;

  @override
  Widget build(BuildContext context) {
    final content = _content;
    final imgW = content.size.width;
    final imgH = content.size.height;
    final board = Rect.fromLTRB(
      content.board.left * imgW,
      content.board.top * imgH,
      content.board.right * imgW,
      content.board.bottom * imgH,
    );
    // The scoreline is baked into fixed image-pixel coordinates on the
    // scoreboard art — kept LTR regardless of app locale so it never mirrors.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: _bg,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Art + scoreline in image-pixel space, cover-scaled together.
            // Vertical alignment adapts to the viewport: cover crops the image
            // bottom, and on short/wide viewports (landscape, split-screen) a
            // fixed topCenter would crop the scoreboard out — so the visible
            // window slides down just enough to keep the board in frame.
            SizedBox.expand(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenAspect = constraints.maxWidth / constraints.maxHeight;
                  final imageAspect = imgW / imgH;
                  // Fraction of the image height visible under cover fit (>=1 → no
                  // vertical crop at all, only the sides are trimmed).
                  final visible = (imageAspect / screenAspect).clamp(0.0, 1.0);
                  var alignY = -1.0; // topCenter
                  final boardBottom = content.board.bottom;
                  if (visible < 1 && visible < boardBottom + 0.05) {
                    // Slide the window down so the board (plus a small margin)
                    // fits: window top t ∈ [0, 1-visible] mapped to [-1, 1].
                    final t = (boardBottom + 0.05 - visible).clamp(0.0, 1.0 - visible);
                    alignY = 1.0 - visible == 0 ? -1.0 : (t / (1.0 - visible)) * 2 - 1;
                  }
                  return FittedBox(
                    fit: BoxFit.cover,
                    alignment: Alignment(0, alignY),
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      width: imgW,
                      height: imgH,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image(
                              image: AssetImage('packages/mapness/assets/tifo/backgrounds/${content.asset}'),
                              fit: BoxFit.fill,
                              errorBuilder: (_, _, _) => const ColoredBox(color: _bg),
                            ),
                          ),
                          Positioned.fromRect(
                            rect: board,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: board.width * 0.12,
                                vertical: board.height * 0.18,
                              ),
                              child: FittedBox(
                                child: Text(
                                  '${result.yourScore} - $scoreToBeat',
                                  style: TextStyle(
                                    fontFamily: TifoText.family,
                                    package: TifoText.package,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 4,
                                    color: content.scoreColor,
                                    shadows: [Shadow(color: content.scoreColor.withValues(alpha: 0.6), blurRadius: 18)],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bottom scrim for text/CTA legibility over the art.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00000000), Color(0xCC000000)],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Spacer(),
                    Text(
                      content.title,
                      textAlign: TextAlign.center,
                      style: TifoText.h2.copyWith(
                        color: _isWin ? TifoColors.accentMuted : Colors.white,
                        fontSize: 32,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      content.message,
                      textAlign: TextAlign.center,
                      style: TifoText.bodyL.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 24),
                    TifoPrimaryButton(
                      label: 'Continue',
                      trailingArrow: true,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The full set of result-hero backgrounds (see [TifoPenaltyResultScreen._content]).
/// Kept in one place so callers can warm the decode ahead of
/// [showTifoPenaltyResult]'s 250ms fade-in, instead of racing it.
const _resultBackgroundAssets = ['result_win.jpg', 'result_loss.jpg', 'result_draw.jpg'];

/// Decodes all three result backgrounds up front. The outcome (and thus which
/// one actually gets shown) is only known after the mini-game ends, so call
/// this as soon as a shootout starts — by the time the fade-in runs, the
/// image is already decoded instead of stalling the first frames on it.
Future<void> precacheTifoResultImages(BuildContext context) => Future.wait([
  for (final asset in _resultBackgroundAssets)
    precacheImage(AssetImage('packages/mapness/assets/tifo/backgrounds/$asset'), context),
]);

/// Pushes the result screen on [context]'s navigator as a fade-in fullscreen.
Future<void> showTifoPenaltyResult(
  BuildContext context,
  TifoPlayResult result, {
  required int scoreToBeat,
}) => Navigator.of(context).push<void>(
  PageRouteBuilder<void>(
    fullscreenDialog: true,
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (_, _, _) => TifoPenaltyResultScreen(result: result, scoreToBeat: scoreToBeat),
    transitionsBuilder: (_, animation, _, child) => FadeTransition(opacity: animation, child: child),
  ),
);
