import 'package:flutter/material.dart';
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
    decoration: const BoxDecoration(
      color: TifoColors.surface,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
              Text('Current Owner', style: TifoText.captionMedium.copyWith(color: TifoColors.accentSoft)),
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
                        const Text('Since 3 days ago', style: TifoText.captionRegular),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('62%', style: TifoText.h2.copyWith(color: TifoColors.accent)),
                      const Text('district control', style: TifoText.captionRegular),
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
              Text('Overview', style: TifoText.captionMedium.copyWith(color: TifoColors.textDefault)),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.apartment_rounded, size: 28, color: TifoColors.accentSoft),
                  const SizedBox(width: 8),
                  _stat('48', 'in this district'),
                  _divider(),
                  _stat('31', 'claimed'),
                  _divider(),
                  _stat('17', 'free'),
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
              const Text('Buildings claimed by each team', style: TifoText.captionMedium),
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
                            const Text('in this district', style: TifoText.captionRegular),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('$claimed', style: TifoText.bodyLSemi),
                          const Text('claimed', style: TifoText.captionRegular),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const TifoPrimaryButton(label: 'Take over the district', trailingArrow: true),
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
                  Text('Current Owner', style: TifoText.captionMedium.copyWith(color: TifoColors.accentSoft)),
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
                          const Text('Since 3 days ago', style: TifoText.captionRegular),
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
                  Text('Unclaimed', style: TifoText.h2.copyWith(color: TifoColors.textSoft)),
                  const SizedBox(height: 4),
                  Text(
                    "This building hasn't been claimed yet.",
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
                      Text('Current score to beat', style: TifoText.captionMedium.copyWith(color: TifoColors.accent)),
                      const SizedBox(height: 4),
                      Text('$score', style: TifoText.h2.copyWith(color: TifoColors.accent)),
                      Text('goals', style: TifoText.captionRegular.copyWith(color: TifoColors.accentSoft)),
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
  const TifoDemoPenaltyPreview({super.key, this.onStart});

  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: const Color(0xFF0A0F0B),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text('Penalty Challenge', style: TifoText.h3.copyWith(color: TifoColors.accentMuted)),
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
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: _card(bg: const Color(0xFF141A15), border: _amber.withValues(alpha: 0.7)),
                    child: Column(
                      children: [
                        Text(
                          '🪙 ${AppLocalizations.of(context).tokensNeeded}',
                          style: TifoText.captionMedium.copyWith(color: _amber),
                        ),
                        const SizedBox(height: 6),
                        Text('1', style: TifoText.h2.copyWith(color: _amber)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: _card(
                      bg: const Color(0xFF141A15),
                      border: TifoColors.accentSoft.withValues(alpha: 0.7),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '🏢 ${AppLocalizations.of(context).claimTheBuilding}',
                          style: TifoText.captionMedium.copyWith(color: TifoColors.accentMuted),
                        ),
                        const SizedBox(height: 6),
                        Text('12', style: TifoText.h2.copyWith(color: TifoColors.accentMuted)),
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
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: _card(bg: const Color(0xFF141A15), border: TifoColors.accentSoft.withValues(alpha: 0.4)),
              child: Text(
                '${AppLocalizations.of(context).youGet3Misses}  ⚽ ⚽ ⚽',
                style: TifoText.bodyLSemi.copyWith(color: TifoColors.accentMuted),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 14),
            TifoPrimaryButton(
              label: AppLocalizations.of(context).startGame,
              leadingEmoji: '⚽',
              onPressed: onStart,
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
              Text('Penalty challenge', style: TifoText.bodyLSemi.copyWith(color: TifoColors.accentMuted)),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _hudCell('misses remaining', const Text('⚽ ❌ ❌', style: TextStyle(fontSize: 16))),
                  const SizedBox(width: 20),
                  _hudCell(
                    'Scored',
                    Text('4', style: TifoText.h3.copyWith(color: TifoColors.accentMuted)),
                    sub: 'goals',
                  ),
                  const SizedBox(width: 20),
                  _hudCell(
                    'Score to beat',
                    Text('12', style: TifoText.h3.copyWith(color: TifoColors.accentMuted)),
                    sub: 'goals',
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

class TifoDemoLeaderboard extends StatelessWidget {
  const TifoDemoLeaderboard({super.key});

  List<(int, String, Color, int, int, int)> _rows(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      (1, l10n.blackTeam, _black, 18, 342, 48),
      (2, l10n.blueTeam, _blue, 14, 268, 46),
      (3, l10n.redTeam, _red, 11, 205, 36),
      (4, l10n.sandTeam, _sand, 8, 142, 25),
      (5, l10n.yellowTeam, _yellow, 6, 98, 17),
    ];
  }

  @override
  Widget build(BuildContext context) => TifoDemoPanel(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: _tab(AppLocalizations.of(context).table, active: true)),
            const SizedBox(width: 8),
            Expanded(child: _tab(AppLocalizations.of(context).profile, active: false)),
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
          decoration: _card(border: TifoColors.accentMuted.withValues(alpha: 0.5)),
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
                        textAlign: TextAlign.end,
                      ),
                    ),
                    const SizedBox(width: 14),
                  ],
                ),
              ),
              for (final (rank, name, color, districts, buildings, pct) in _rows(context))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    children: [
                      SizedBox(width: 18, child: Text('$rank', style: TifoText.bodyLSemi)),
                      Expanded(
                        flex: 4,
                        child: Row(
                          children: [
                            _Crest(color, size: 22),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                name,
                                style: TifoText.bodyLSemi.copyWith(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('$districts', style: TifoText.bodyL, textAlign: TextAlign.center),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('$buildings', style: TifoText.bodyL, textAlign: TextAlign.center),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('$pct%', style: TifoText.captionMedium.copyWith(color: TifoColors.textDefault)),
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
                      const SizedBox(width: 2),
                      const Icon(Icons.chevron_right_rounded, size: 14, color: TifoColors.textSoft),
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

  static Widget _tab(String label, {required bool active}) => Container(
    height: 42,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: active ? TifoColors.accent : TifoColors.surface,
      borderRadius: BorderRadius.circular(TifoRadii.ml),
      border: Border.all(color: active ? TifoColors.accent : TifoColors.border),
    ),
    child: Text(
      label,
      style: TifoText.bodyLSemi.copyWith(color: active ? TifoColors.onAccent : TifoColors.textDefault),
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
                Expanded(child: _statCard('Current tokens', '⚡ 15')),
                const SizedBox(width: 10),
                Expanded(child: _statCard('Next daily tokens in', '🕐 08:24:17', sub: 'mm:ss')),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _statCard('Every trip you complete\nearns you tokens.', '📍 3')),
                const SizedBox(width: 10),
                Expanded(child: _statCard('Tokens earned', '🏦 64', sub: 'All time')),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: _card(border: TifoColors.accentMuted.withValues(alpha: 0.5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🎮 Matches Played', style: TifoText.bodyLSemi),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _matchStat('32', 'Total'),
                      _matchStat('18', 'Wins'),
                      _matchStat('7', 'Losses'),
                      _matchStat('18', 'Claimed'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Expanded(child: Text('Recent Activity', style: TifoText.bodyLSemi)),
                Text('View all ›', style: TifoText.captionMedium.copyWith(color: TifoColors.accent)),
              ],
            ),
            const SizedBox(height: 8),
            _activity('🏆', 'You won a penalty challenge', '2h ago'),
            _activity('❌', 'You lost a penalty challenge', '2h ago'),
            _activity('📍', 'Trip completed  +3 ⚡', '5h ago'),
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

  static Widget _activity(String emoji, String text, String time) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
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
  const TifoDemoSupport({super.key});

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
      color: TifoColors.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: TifoColors.textDefault),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context).support, style: TifoText.h3),
                      Text(
                        AppLocalizations.of(context).learnTheRulesAndGetAnswersToCommonQuestions,
                        style: TifoText.captionRegular.copyWith(color: TifoColors.accentSoft),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TifoPrimaryButton(label: AppLocalizations.of(context).replayTutorial, trailingArrow: true),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  '✦✦  ${AppLocalizations.of(context).howToPlay}  ✦✦',
                  style: TifoText.overline.copyWith(letterSpacing: 2),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context).takeOverBuildingsByBeatingTheScoreInAPenaltyMatch,
                style: TifoText.captionMedium.copyWith(color: TifoColors.textDefault),
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
                          child: Text(steps[i], style: TifoText.bodyL.copyWith(fontSize: 14)),
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
            const TifoStepHeader(step: 1, total: 2, title: 'Choose your team'),
            const SizedBox(height: 4),
            const TifoInfoBanner(
              icon: Icons.lock_outline_rounded,
              title: 'Your team will be locked for the season',
              subtitle: 'You can change teams when the next season begins.',
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
