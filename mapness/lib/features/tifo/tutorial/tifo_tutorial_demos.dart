import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/features/tifo/providers/tifo_session_provider.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

/// Static demo replicas of the TIFO screens shown during the guided tutorial
/// (Figma tutorial sequence, nodes 721:126769 / 601:108243 / 601:108497 /
/// 721:126912 / 589:85315 / 601:108871 / 722:133404 / 722:133115 / 600:95555 /
/// 721:126548). All content is canned — the tour never touches the backend.

// Design demo palette (the 5 anonymized teams).
const _blue = Color(0xFF1500FF);
const _yellow = Color(0xFFFFE100);
const _black = Color(0xFF1B1B1B);
const _red = Color(0xFFF63D33);
const _sand = Color(0xFFD2B48C);
const _amber = Color(0xFFD97706);
const _purple = Color(0xFF7C3AED);

// ─── Shared bits ─────────────────────────────────────────────────────────────

/// Slot order for the demo screens — the design's five teams in the order the
/// tour has always shown them. Fixed on purpose: the canned stats are laid
/// over these slots, so reordering them would silently reassign the demo
/// standings.
const List<Color> _demoSlotColors = [_black, _blue, _red, _sand, _yellow];

/// Teams for the demo screens: the REAL season clubs (name + crest color from
/// `/clubs`) whenever the roster is loaded, so the tour doesn't teach five
/// anonymized colors that exist nowhere in the live game.
///
/// Clubs are placed into [_demoSlotColors] by nearest crest color, each club
/// used at most once — that keeps the tour's long-standing slot ORDER (and
/// therefore which team leads the demo table) while the labels become real.
/// Matching by color rather than by slug or roster position follows
/// `tifoNearestStrikerColor`'s reasoning: nothing here may assume which club
/// the backend calls "blue".
///
/// The design palette stays as the FALLBACK for an empty roster — the tour can
/// be opened before `/clubs` answers, or with no network at all, and a demo
/// screen must never render an empty table. A season with more than five clubs
/// shows the five closest to the design slots, exactly as many rows as before.
List<(String, Color)> _demoTeams(BuildContext context, List<TifoClubInfo> clubs) {
  if (clubs.isEmpty) {
    final l10n = AppLocalizations.of(context);
    return [
      (l10n.blackTeam, _black),
      (l10n.blueTeam, _blue),
      (l10n.redTeam, _red),
      (l10n.sandTeam, _sand),
      (l10n.yellowTeam, _yellow),
    ];
  }
  final pool = [...clubs];
  final teams = <(String, Color)>[];
  for (final slot in _demoSlotColors) {
    if (pool.isEmpty) {
      break;
    }
    var best = 0;
    var bestDistance = double.infinity;
    for (var i = 0; i < pool.length; i++) {
      final distance = _rgbDistance(slot.toARGB32(), pool[i].colorArgb);
      if (distance < bestDistance) {
        bestDistance = distance;
        best = i;
      }
    }
    final club = pool.removeAt(best);
    teams.add((club.name, Color(club.colorArgb)));
  }
  return teams;
}

/// Squared RGB distance between two ARGB values (alpha ignored) — same
/// primitive `_nearestColorBucket` uses in `penalty_game.dart`.
double _rgbDistance(int a, int b) {
  final dr = ((a >> 16) & 0xFF) - ((b >> 16) & 0xFF);
  final dg = ((a >> 8) & 0xFF) - ((b >> 8) & 0xFF);
  final db = (a & 0xFF) - (b & 0xFF);
  return (dr * dr + dg * dg + db * db).toDouble();
}

BoxDecoration _card({Color? bg, Color? border, double radius = TifoRadii.l}) => BoxDecoration(
  color: bg ?? TifoColors.surface,
  borderRadius: BorderRadius.circular(radius),
  border: Border.all(color: border ?? TifoColors.border),
);

class _Crest extends StatelessWidget {
  const _Crest(this.color, {this.size = 44});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(size * 0.27)),
  );
}

/// White demo panel pinned to the bottom of the tour overlay (the design shows
/// these as sheets over the dimmed map).
class TifoDemoPanel extends StatelessWidget {
  const TifoDemoPanel({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: context.colors.backgroundSurface1,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
    ),
    child: SafeArea(
      top: false,
      child: Padding(padding: const EdgeInsets.fromLTRB(16, 10, 16, 16), child: child),
    ),
  );
}

// ─── 02 · District details (Downtown Riyadh) ────────────────────────────────

class TifoDemoDistrictSheet extends StatelessWidget {
  const TifoDemoDistrictSheet({super.key});

  List<(String, Color, int)> _rows(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      (l10n.blueTeam, _blue, 31),
      (l10n.yellowTeam, _yellow, 12),
      (l10n.blackTeam, _black, 4),
      (l10n.redTeam, _red, 2),
      (l10n.sandTeam, _sand, 2),
    ];
  }

  @override
  Widget build(BuildContext context) => TifoDemoPanel(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Text('Downtown Riyadh', style: TifoText.captionMedium.copyWith(color: TifoColors.accent)),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: _card(bg: TifoColors.accentContainer, border: TifoColors.accentMuted.withValues(alpha: 0.5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).tifoCurrentOwner,
                style: TifoText.captionMedium.copyWith(color: TifoColors.accentSoft),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const _Crest(_sand),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Team Name', style: TifoText.bodyLSemi.copyWith(color: TifoColors.accent)),
                        Text(
                          '${AppLocalizations.of(context).tifoSince} ${tifoStandingDaysAgo(context, 3)}',
                          style: TifoText.captionRegular,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('62%', style: TifoText.h2.copyWith(color: TifoColors.accent)),
                      Text(AppLocalizations.of(context).tifoDistrictControl, style: TifoText.captionRegular),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: _card(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).tifoOverview,
                style: TifoText.captionMedium.copyWith(color: TifoColors.textDefault),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.apartment_rounded, size: 28, color: TifoColors.accentSoft),
                  const SizedBox(width: 8),
                  _stat('48', AppLocalizations.of(context).tifoInThisDistrict),
                  _divider(),
                  _stat('31', AppLocalizations.of(context).claimed),
                  _divider(),
                  _stat('17', AppLocalizations.of(context).tifoFree),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: _card(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context).tifoBuildingsClaimedByEachTeam, style: TifoText.captionMedium),
              const SizedBox(height: 4),
              for (final (name, color, claimed) in _rows(context))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: TifoText.bodyLSemi.copyWith(color: color == _yellow ? _amber : color)),
                            Text(AppLocalizations.of(context).tifoInThisDistrict, style: TifoText.captionRegular),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('$claimed', style: TifoText.bodyLSemi),
                          Text(AppLocalizations.of(context).claimed, style: TifoText.captionRegular),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TifoPrimaryButton(label: AppLocalizations.of(context).tifoTakeOverTheDistrict, trailingArrow: true),
      ],
    ),
  );

  static Widget _stat(String value, String label) => Expanded(
    child: Column(
      children: [
        Text(value, style: TifoText.h3.copyWith(color: TifoColors.accent)),
        Text(label, style: TifoText.captionRegular, textAlign: TextAlign.center),
      ],
    ),
  );

  static Widget _divider() => Container(width: 1, height: 32, color: TifoColors.border);
}

// ─── 04 / 05 / 08 · Building sheet states ───────────────────────────────────

enum TifoDemoBuildingState { unclaimed, owned, claimed }

class TifoDemoBuildingSheet extends StatelessWidget {
  const TifoDemoBuildingSheet({required this.state, super.key});

  final TifoDemoBuildingState state;

  @override
  Widget build(BuildContext context) {
    final owned = state != TifoDemoBuildingState.unclaimed;
    final score = switch (state) {
      TifoDemoBuildingState.unclaimed => 0,
      TifoDemoBuildingState.owned => 12,
      TifoDemoBuildingState.claimed => 13,
    };
    final played = switch (state) {
      TifoDemoBuildingState.unclaimed => 0,
      TifoDemoBuildingState.owned => 5,
      TifoDemoBuildingState.claimed => 6,
    };
    return TifoDemoPanel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: TifoColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: TifoColors.border),
              ),
              child: const Icon(Icons.close_rounded, size: 16, color: TifoColors.accentSoft),
            ),
          ),
          Center(child: Text(AppLocalizations.of(context).claimTheBuilding, style: TifoText.h3)),
          const SizedBox(height: 14),
          if (owned)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: _card(
                bg: TifoColors.accentContainer,
                border: TifoColors.accentMuted.withValues(alpha: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).tifoCurrentOwner,
                    style: TifoText.captionMedium.copyWith(color: TifoColors.accentSoft),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const _Crest(_sand),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).sandTeam,
                            style: TifoText.bodyLSemi.copyWith(color: TifoColors.accent),
                          ),
                          Text(
                            '${AppLocalizations.of(context).tifoSince} ${tifoStandingDaysAgo(context, 3)}',
                            style: TifoText.captionRegular,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(14),
              decoration: _card(bg: const Color(0xFFF5F6F8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).tifoUnclaimed,
                    style: TifoText.h2.copyWith(color: TifoColors.textSoft),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context).tifoNotClaimedYet,
                    style: TifoText.captionRegular.copyWith(color: TifoColors.accentSoft),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: _card(border: TifoColors.textStrong),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).tifoCurrentScoreToBeat,
                        style: TifoText.captionMedium.copyWith(color: TifoColors.accent),
                      ),
                      const SizedBox(height: 4),
                      Text('$score', style: TifoText.h2.copyWith(color: TifoColors.accent)),
                      Text(
                        AppLocalizations.of(context).tifoGoals,
                        style: TifoText.captionRegular.copyWith(color: TifoColors.accentSoft),
                      ),
                    ],
                  ),
                ),
                const Text('⚽', style: TextStyle(fontSize: 28)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: _card(border: TifoColors.textStrong),
            child: Row(
              children: [
                Text('$played', style: TifoText.h3.copyWith(color: TifoColors.accent)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    played == 0
                        ? 'This building has not been played yet.'
                        : 'This building has been played $played times\nin the last 7 days.',
                    style: TifoText.captionMedium.copyWith(color: TifoColors.textDefault),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: _card(bg: const Color(0xFFF7F5FF), border: _purple.withValues(alpha: 0.4)),
            child: Row(
              children: [
                const Icon(Icons.bolt_rounded, size: 18, color: _purple),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Win the challenge and dominate with your team',
                    style: TifoText.captionMedium.copyWith(color: _purple),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const TifoPrimaryButton(label: 'Challenge', leadingEmoji: '⚽', trailingArrow: true),
        ],
      ),
    );
  }
}

// ─── 06 · Penalty challenge preview (dark) ──────────────────────────────────

class TifoDemoPenaltyPreview extends StatelessWidget {
  const TifoDemoPenaltyPreview({super.key, this.onStart, this.onBack, this.onClose});

  final VoidCallback? onStart;
  final VoidCallback? onBack;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) => ColoredBox(
    // Figma "Game preview": the screen is one deep-green field (#0C3330) in
    // both themes, with a 10% accent wash over it. It was a near-black
    // (#0A0F0B) here, which read as a different screen entirely.
    color: TifoColors.penaltyField,
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context).tifoPenaltyChallenge,
                  style: TifoText.h3.copyWith(color: TifoColors.accent),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(TifoRadii.l),
                    child: const Image(
                      image: AssetImage('packages/mapness/assets/tifo/images/penalty_preview.png'),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: _card(bg: TifoColors.warnWash, border: TifoColors.warn),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '🪙 ${AppLocalizations.of(context).tokensNeeded}',
                                style: TifoText.captionMedium.copyWith(color: TifoColors.warn),
                              ),
                              Text('2', style: TifoText.h2.copyWith(color: TifoColors.warnStrong)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: _card(bg: TifoColors.accentContainer, border: TifoColors.accent),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '🏢 ${AppLocalizations.of(context).claimTheBuilding}',
                                style: TifoText.captionMedium.copyWith(color: TifoColors.accentMuted),
                              ),
                              Text('12', style: TifoText.h2.copyWith(color: TifoColors.accentBright)),
                              Text(
                                AppLocalizations.of(context).beatTheScore,
                                style: TifoText.captionRegular.copyWith(color: TifoColors.accentMuted),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: _card(bg: TifoColors.accentContainer, border: TifoColors.accentMuted),
                  child: Text(
                    '${AppLocalizations.of(context).youGet3Misses}  ⚽ ⚽ ⚽',
                    style: TifoText.bodyLSemi.copyWith(color: TifoColors.accentMuted),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    if (onBack != null) ...[
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
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16,
                            color: context.colors.neutralOnContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: TifoPrimaryButton(
                        label: AppLocalizations.of(context).startGame,
                        leadingEmoji: '⚽',
                        onPressed: onStart,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (onClose != null)
              Positioned(
                top: 0,
                left: 0,
                child: GestureDetector(
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
              ),
          ],
        ),
      ),
    ),
  );
}

// ─── 07 · Penalty HUD (dark, mid-game snapshot) ─────────────────────────────

class TifoDemoPenaltyHud extends StatelessWidget {
  const TifoDemoPenaltyHud({super.key});

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('packages/mapness/assets/tifo/backgrounds/stadium_goal_background.jpg'),
        fit: BoxFit.cover,
      ),
    ),
    child: SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xE0101711),
            borderRadius: BorderRadius.circular(TifoRadii.l),
            border: Border.all(color: TifoColors.accentSoft.withValues(alpha: 0.4)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context).tifoPenaltyChallenge,
                style: TifoText.bodyLSemi.copyWith(color: TifoColors.accentMuted),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _hudCell(
                    AppLocalizations.of(context).tifoMissesRemaining,
                    // Mirrors the live HUD (ball asset + explicit cross)
                    // rather than an emoji string, whose glyphs — and colors —
                    // changed with the app language.
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TifoBallIcon(size: 16),
                        SizedBox(width: 4),
                        TifoMissMark(size: 16),
                        SizedBox(width: 4),
                        TifoMissMark(size: 16),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  _hudCell(
                    AppLocalizations.of(context).tifoScored,
                    Text('4', style: TifoText.h3.copyWith(color: TifoColors.accentMuted)),
                    sub: AppLocalizations.of(context).tifoGoals,
                  ),
                  const SizedBox(width: 20),
                  _hudCell(
                    AppLocalizations.of(context).tifoScoreToBeat,
                    Text('12', style: TifoText.h3.copyWith(color: TifoColors.accentMuted)),
                    sub: AppLocalizations.of(context).tifoGoals,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

  static Widget _hudCell(String label, Widget value, {String? sub}) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(label, style: TifoText.captionMedium.copyWith(color: TifoColors.accentMuted)),
      const SizedBox(height: 4),
      value,
      if (sub != null) Text(sub, style: TifoText.captionRegular.copyWith(color: TifoColors.accentMuted)),
    ],
  );
}

// ─── 09 · Leaderboard (Table tab) ───────────────────────────────────────────

class TifoDemoLeaderboard extends ConsumerWidget {
  const TifoDemoLeaderboard({super.key});

  /// Canned standings (the tour never asks the backend for numbers) laid over
  /// the real clubs from [_demoTeams]. Capped by the shorter of the two lists,
  /// so a season running fewer than five clubs renders a shorter table rather
  /// than teams with no stats — or stats with no team.
  static const List<(int, int, int)> _stats = [
    (18, 342, 32),
    (14, 268, 25),
    (11, 205, 19),
    (8, 142, 13),
    (6, 98, 11),
  ];

  List<(int, String, Color, int, int, int)> _rows(BuildContext context, WidgetRef ref) {
    final teams = _demoTeams(context, ref.watch(tifoSessionProvider.select((s) => s.clubs)));
    return [
      for (var i = 0; i < teams.length && i < _stats.length; i++)
        (i + 1, teams[i].$1, teams[i].$2, _stats[i].$1, _stats[i].$2, _stats[i].$3),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => TifoDemoPanel(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: _tab(AppLocalizations.of(context).table, active: true, context: context)),
            const SizedBox(width: 8),
            Expanded(child: _tab(AppLocalizations.of(context).profile, active: false, context: context)),
          ],
        ),
        const SizedBox(height: 12),
        TifoInfoBanner(
          icon: Icons.emoji_events_rounded,
          title: AppLocalizations.of(context).battleForControlContinues,
          subtitle: AppLocalizations.of(context).competeWithOtherTeamsToClaimTheCity,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: _card(
            border: TifoColors.accentMuted.withValues(alpha: 0.5),
            bg: context.colors.backgroundSurface1,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const SizedBox(width: 18, child: Text('#', style: TifoText.captionMedium)),
                    Expanded(
                      flex: 4,
                      child: Text(AppLocalizations.of(context).team, style: TifoText.captionMedium),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        AppLocalizations.of(context).districtsClaimed,
                        style: TifoText.captionMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        AppLocalizations.of(context).buildingsClaimed,
                        style: TifoText.captionMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        AppLocalizations.of(context).mapDominance,
                        style: TifoText.captionMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 14),
                  ],
                ),
              ),
              for (final (rank, name, color, districts, buildings, pct) in _rows(context, ref))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 18,
                        child: Text(
                          '$rank',
                          style: TifoText.bodyLSemi.copyWith(color: context.colors.foregroundDefault),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Row(
                          children: [
                            _Crest(color, size: 22),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                name,
                                style: TifoText.bodyLSemi.copyWith(
                                  fontSize: 13,
                                  color: context.colors.foregroundDefault,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '$districts',
                          style: TifoText.bodyL.copyWith(
                            color: context.colors.foregroundDefault,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '$buildings',
                          style: TifoText.bodyL.copyWith(
                            color: context.colors.foregroundDefault,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$pct%',
                              style: TifoText.captionMedium.copyWith(color: context.colors.foregroundDefault),
                            ),
                            const SizedBox(height: 3),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: pct / 100,
                                minHeight: 5,
                                backgroundColor: TifoColors.border,
                                valueColor: const AlwaysStoppedAnimation(TifoColors.accent),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: _card(bg: TifoColors.accentContainer, border: Colors.transparent),
          child: Row(
            children: [
              const Icon(Icons.bolt_rounded, size: 16, color: _purple),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppLocalizations.of(context).takeOverMoreBuildingsToDominateTheTable,
                  style: TifoText.captionMedium.copyWith(color: TifoColors.accentSoft),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TifoPrimaryButton(label: AppLocalizations.of(context).dominateWithYourTeam, trailingArrow: true),
      ],
    ),
  );

  Widget _tab(String label, {required bool active, required BuildContext context}) => Container(
    height: 42,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: active ? TifoColors.accent : context.colors.backgroundSurface1,
      borderRadius: BorderRadius.circular(TifoRadii.ml),
      border: Border.all(color: active ? TifoColors.accent : TifoColors.border),
    ),
    child: Text(
      label,
      style: TifoText.bodyLSemi.copyWith(color: active ? TifoColors.onAccent : context.colors.foregroundDefault),
    ),
  );
}

// ─── 10 / 11 · Profile / dashboard ──────────────────────────────────────────

class TifoDemoProfile extends StatelessWidget {
  const TifoDemoProfile({super.key});

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: TifoColors.surface,
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 44),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: _card(
                bg: TifoColors.accentContainer,
                border: TifoColors.accentMuted.withValues(alpha: 0.5),
              ),
              child: Row(
                children: [
                  const _Crest(_black),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).blackTeam,
                          style: TifoText.bodyLSemi.copyWith(color: TifoColors.accent),
                        ),
                        const Text('Date Joined: 12 Aug 2026', style: TifoText.captionRegular),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: _black, borderRadius: BorderRadius.circular(6)),
                        child: const Text(
                          '2',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const Text('Team Rank', style: TifoText.captionRegular),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _statCard(AppLocalizations.of(context).currentTokens, '⚡ 15')),
                const SizedBox(width: 10),
                Expanded(
                  child: _statCard(AppLocalizations.of(context).nextDailyTokensIn, '🕐 08:24:17', sub: 'mm:ss'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _statCard(AppLocalizations.of(context).everyTripYouCompleteEarnsYouTokens, '📍 3'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _statCard(
                    AppLocalizations.of(context).tokensEarned,
                    '🏦 64',
                    sub: AppLocalizations.of(context).allTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: _card(border: TifoColors.accentMuted.withValues(alpha: 0.5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🎮 ${AppLocalizations.of(context).matchesPlayed}', style: TifoText.bodyLSemi),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _matchStat('32', AppLocalizations.of(context).total),
                      _matchStat('18', AppLocalizations.of(context).wins),
                      _matchStat('7', AppLocalizations.of(context).losses),
                      _matchStat('18', AppLocalizations.of(context).claimed),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: Text(AppLocalizations.of(context).recentActivity, style: TifoText.bodyLSemi)),
                Text(
                  '${AppLocalizations.of(context).viewAll} ›',
                  style: TifoText.captionMedium.copyWith(color: TifoColors.accent),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _activity(
              const Text('🏆', style: TextStyle(fontSize: 16)),
              AppLocalizations.of(context).youWonAPenaltyChallenge,
              '2h ago',
            ),
            _activity(
              const TifoMissMark(size: 16),
              AppLocalizations.of(context).youLostAPenaltyChallenge,
              '2h ago',
            ),
            _activity(
              // Same artwork the live activity list uses for this row.
              Assets.imagesSvg.tifoTripMarker.svg(height: 16),
              '${AppLocalizations.of(context).tripCompleted}  +3 ⚡',
              '5h ago',
            ),
            const Spacer(),
            TifoPrimaryButton(label: AppLocalizations.of(context).dominateWithYourTeam, trailingArrow: true),
          ],
        ),
      ),
    ),
  );

  static Widget _statCard(String label, String value, {String? sub}) => Container(
    padding: const EdgeInsets.all(12),
    decoration: _card(border: TifoColors.accentMuted.withValues(alpha: 0.5)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TifoText.captionRegular),
        const SizedBox(height: 6),
        Text(value, style: TifoText.h3),
        if (sub != null) Text(sub, style: TifoText.captionRegular),
      ],
    ),
  );

  static Widget _matchStat(String value, String label) => Expanded(
    child: Column(
      children: [
        Text(value, style: TifoText.h3),
        Text(label, style: TifoText.captionRegular),
      ],
    ),
  );

  static Widget _activity(Widget leading, String text, String time) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        leading,
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: TifoText.captionMedium.copyWith(color: TifoColors.textDefault)),
        ),
        Text(time, style: TifoText.captionRegular),
      ],
    ),
  );
}

// ─── 12 · Support ───────────────────────────────────────────────────────────

class TifoDemoSupport extends StatelessWidget {
  const TifoDemoSupport({super.key, this.onReplayTutorial, this.replayBusy = false});

  /// Support → "Replay tutorial" (BE-233 / build 3.30.1: the button rendered
  /// permanently disabled because no handler was ever passed). Null keeps the
  /// button in its disabled look for the pure-replica usages.
  final VoidCallback? onReplayTutorial;

  /// True while the replay is resetting the persisted tutorial flags, so a
  /// double tap can't restart the tour twice.
  final bool replayBusy;

  /// One "How to play" sparkle. A widget span carries no ambient text style,
  /// so it restates the header's own ([TifoText.overline]) and pads for the
  /// letter-spacing the header applies to real text spans.
  static InlineSpan _sparkle(double size) => WidgetSpan(
    alignment: PlaceholderAlignment.middle,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Text('✦', style: TifoText.overline.copyWith(fontSize: size)),
    ),
  );

  List<String> _steps(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      l10n.tifoHowToPlayStep1,
      l10n.tifoHowToPlayStep2,
      l10n.tifoHowToPlayStep3,
      l10n.tifoHowToPlayStep4,
      l10n.tifoHowToPlayStep5,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final steps = _steps(context);
    return ColoredBox(
      color: context.colors.backgroundSurface1,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).support,
                        style: TifoText.h3.copyWith(color: context.colors.foregroundDefault),
                      ),
                      Text(
                        AppLocalizations.of(context).learnTheRulesAndGetAnswersToCommonQuestions,
                        style: TifoText.captionRegular.copyWith(color: TifoColors.accentSoft),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TifoPrimaryButton(
                label: AppLocalizations.of(context).replayTutorial,
                trailingArrow: true,
                busy: replayBusy,
                onPressed: onReplayTutorial,
              ),
              const SizedBox(height: 20),
              Center(
                // Per-glyph sizes (10/7 … 7/10) — the sparkles taper towards
                // the label, so they can't share one Text style. They ride in
                // WidgetSpans rather than TextSpans because text spans align on
                // the BASELINE, which drops the small ones below the line;
                // `PlaceholderAlignment.middle` centres every sparkle on the
                // label's own middle instead.
                child: Text.rich(
                  TextSpan(
                    children: [
                      _sparkle(10),
                      _sparkle(7),
                      TextSpan(text: '  ${AppLocalizations.of(context).howToPlay}  '),
                      _sparkle(7),
                      _sparkle(10),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: TifoText.overline.copyWith(letterSpacing: 2),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context).takeOverBuildingsByBeatingTheScoreInAPenaltyMatch,
                style: TifoText.captionMedium.copyWith(color: context.colors.foregroundDefault),
              ),
              const SizedBox(height: 14),
              for (var i = 0; i < steps.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: TifoColors.accent,
                          borderRadius: BorderRadius.circular(TifoRadii.ml),
                        ),
                        child: Text('${i + 1}', style: TifoText.bodyLSemi.copyWith(color: Colors.white)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            steps[i],
                            style: TifoText.bodyL.copyWith(fontSize: 14, color: context.colors.foregroundDefault),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── 13 · Team select ───────────────────────────────────────────────────────

class TifoDemoTeamSelect extends StatelessWidget {
  const TifoDemoTeamSelect({super.key});

  List<(String, Color, bool)> _teams(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      (l10n.blueTeam, _blue, false),
      (l10n.yellowTeam, _yellow, false),
      (l10n.blackTeam, _black, false),
      (l10n.redTeam, _red, true),
      (l10n.sandTeam, _sand, false),
    ];
  }

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: TifoColors.surface,
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TifoStepHeader(step: 1, total: 2, title: AppLocalizations.of(context).chooseYourTeam),
            const SizedBox(height: 4),
            TifoInfoBanner(
              icon: Icons.lock_outline_rounded,
              title: AppLocalizations.of(context).yourTeamWillBeLockedForTheSeason,
              subtitle: AppLocalizations.of(context).youCanChangeTeamsWhenTheNextSeasonBegins,
            ),
            const SizedBox(height: 12),
            for (final (name, color, selected) in _teams(context))
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  height: 86,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(TifoRadii.l),
                    border: selected ? Border.all(color: TifoColors.accent, width: 2) : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(name, style: TifoText.bodyLSemi.copyWith(color: tifoInkOn(color))),
                      ),
                      if (selected)
                        const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.check_rounded, size: 16, color: TifoColors.accent),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
