import 'package:flutter/material.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// Fullscreen post-penalty result (BRD US-14) — one full-bleed hero per
/// outcome, art baked with its own localized title/message (an `_en` variant
/// per file), so this screen renders nothing on top of it besides the
/// Continue button. The score is NOT shown here — it's already visible
/// throughout the game, so repeating it on this screen was redundant.
class TifoPenaltyResultScreen extends StatelessWidget {
  const TifoPenaltyResultScreen({
    required this.result,
    required this.winnerColorKey,
    required this.buildingOwnerColorKeyBeforePlay,
    super.key,
  });

  final TifoPlayResult result;

  /// Result color key (see [tifoResultColorKeys]) for the WINNING club —
  /// only meaningful (and only used) on a win.
  final String? winnerColorKey;

  /// Result color key for the building's owner BEFORE this attempt — only
  /// meaningful (and only used) on a loss/tie. `null` means the building was
  /// unclaimed, which has its own dedicated art.
  final String? buildingOwnerColorKeyBeforePlay;

  static const _bg = Color(0xFF0A0F0B);

  String _asset(BuildContext context) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    final suffix = isEnglish ? '_en' : '';
    return switch (result.outcome) {
      TifoOutcome.claimed || TifoOutcome.taken => 'result_win_${winnerColorKey ?? 'blue'}$suffix.png',
      // A voided (expired) session captured nothing, which BRD FR-17 calls a
      // loss — the player gets the same "So close!" hero as a lost match.
      TifoOutcome.failed || TifoOutcome.voided =>
        buildingOwnerColorKeyBeforePlay != null
            ? 'result_lose_$buildingOwnerColorKeyBeforePlay$suffix.png'
            : 'result_lose_unclaimed$suffix.png',
      // No dedicated art for an unrecognized outcome — neutral background.
      TifoOutcome.unknown => 'result_draw.jpg',
    };
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Image(
            image: AssetImage('packages/mapness/assets/tifo/backgrounds/${_asset(context)}'),
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const ColoredBox(color: _bg),
          ),
        ),
        // Bottom scrim for the CTA's legibility over the art.
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TifoPrimaryButton(
                  label: context.l10n.tifoContinue,
                  trailingArrow: true,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

/// The full set of result-hero backgrounds (see [TifoPenaltyResultScreen._asset]).
/// Kept in one place so callers can warm the decode ahead of
/// [showTifoPenaltyResult]'s 250ms fade-in, instead of racing it. Only the
/// two assets that can actually be shown for THIS attempt are precached
/// (the player's own win art + the building's current-owner lose art) —
/// not the full ~22-file set — since both are already known before the
/// mini-game starts.
List<String> _resultBackgroundAssetsFor({required String? winnerColorKey, required String? buildingOwnerColorKey}) {
  final winColor = winnerColorKey ?? 'blue';
  final loseSuffix = buildingOwnerColorKey ?? 'unclaimed';
  return [
    'result_win_$winColor.png',
    'result_win_${winColor}_en.png',
    'result_lose_$loseSuffix.png',
    'result_lose_${loseSuffix}_en.png',
  ];
}

Future<void> precacheTifoResultImages(
  BuildContext context, {
  required String? winnerColorKey,
  required String? buildingOwnerColorKey,
}) => Future.wait([
  for (final asset in _resultBackgroundAssetsFor(
    winnerColorKey: winnerColorKey,
    buildingOwnerColorKey: buildingOwnerColorKey,
  ))
    precacheImage(AssetImage('packages/mapness/assets/tifo/backgrounds/$asset'), context),
]);

/// Pushes the result screen on [context]'s navigator as a fade-in fullscreen.
Future<void> showTifoPenaltyResult(
  BuildContext context,
  TifoPlayResult result, {
  required String? winnerColorKey,
  required String? buildingOwnerColorKeyBeforePlay,
}) => Navigator.of(context).push<void>(
  PageRouteBuilder<void>(
    fullscreenDialog: true,
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (_, _, _) => TifoPenaltyResultScreen(
      result: result,
      winnerColorKey: winnerColorKey,
      buildingOwnerColorKeyBeforePlay: buildingOwnerColorKeyBeforePlay,
    ),
    transitionsBuilder: (_, animation, _, child) => FadeTransition(opacity: animation, child: child),
  ),
);
