import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/tifo/data/tifo_api.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/features/tifo/providers/tifo_session_provider.dart';
import 'package:mapness/features/tifo/tifo_journey.dart';
import 'package:mapness/features/tifo/tifo_login.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

/// Club standings, fetched fresh each time the sheet opens.
final tifoLeaderboardProvider = FutureProvider.autoDispose<List<TifoLeaderRow>>(
  (ref) => ref.read(tifoApiProvider).getLeaderboards(),
);

/// Leaderboard + Dashboard bottom-sheet (BRD US-09/US-10), one panel with
/// Table / Profile tabs, opened from the trophy map control.
Future<void> showTifoLeaderboardSheet(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  backgroundColor: TifoColors.surface,
  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
  builder: (_) => const _LeaderboardSheet(),
);

class _LeaderboardSheet extends ConsumerStatefulWidget {
  const _LeaderboardSheet();

  @override
  ConsumerState<_LeaderboardSheet> createState() => _LeaderboardSheetState();
}

class _LeaderboardSheetState extends ConsumerState<_LeaderboardSheet> {
  int _tab = 0; // 0 = Table (leaderboard), 1 = Profile (dashboard)

  @override
  void initState() {
    super.initState();
    // Opened straight from the trophy control (no team-select first), so the
    // roster may not be loaded — without it club rows show slugs + grey crests.
    if (ref.read(tifoSessionProvider).clubs.isEmpty) {
      Future.microtask(() => ref.read(tifoSessionProvider.notifier).load());
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(color: TifoColors.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(BorderSide(color: TifoColors.border)),
                  ),
                  child: const Icon(Icons.close_rounded, size: 18, color: TifoColors.textSoft),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _Tabs(tab: _tab, onChanged: (t) => setState(() => _tab = t)),
            const SizedBox(height: 16),
            Flexible(child: _tab == 0 ? _buildTable() : _buildProfile()),
            const SizedBox(height: 12),
            TifoPrimaryButton(
              label: AppLocalizations.of(context).dominateWithYourTeam,
              trailingArrow: true,
              // Play-intent CTA (BRD FR-03/FR-04): walk the gates (login →
              // tutorial → team select) on top of the sheet — popping first
              // would dispose this ref mid-journey. Close to the map only
              // once the player is play-ready; on cancel stay on the sheet.
              onPressed: () async {
                final gateCtx = rootNavigatorKey.currentContext;
                if (gateCtx == null) {
                  return;
                }
                final ready = await TifoJourney(ref).ensurePlayReady(gateCtx);
                if (ready && mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildTable() {
    final rows = ref.watch(tifoLeaderboardProvider);
    final session = ref.watch(tifoSessionProvider);
    return rows.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator(color: TifoColors.accent)),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(24),
        child: Text('Could not load standings.\n$e', style: TifoText.captionRegular),
      ),
      data: (list) => ListView(
        shrinkWrap: true,
        children: [
          TifoInfoBanner(
            icon: Icons.emoji_events_rounded,
            title: AppLocalizations.of(context).battleForControlContinues,
            subtitle: AppLocalizations.of(context).competeWithOtherTeamsToClaimTheCity,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: TifoColors.surface,
              borderRadius: BorderRadius.circular(TifoRadii.l),
              border: Border.all(color: TifoColors.accentMuted.withValues(alpha: 0.5), width: 1.5),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      const SizedBox(width: 20, child: Text('#', style: TifoText.captionMedium)),
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
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
                for (final row in list) _LeaderRowTile(row: row, club: session.clubById(row.clubId)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: TifoColors.accentContainer,
              borderRadius: BorderRadius.circular(TifoRadii.ml),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(color: Color(0xFFEDE9FE), shape: BoxShape.circle),
                  child: const Icon(Icons.bolt_rounded, size: 16, color: Color(0xFF7C3AED)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).takeOverMoreBuildingsToDominateTheTable,
                    style: TifoText.captionMedium.copyWith(color: TifoColors.accentSoft, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Profile / dashboard tab — Figma nodes 696:117570 (signed out) and
  /// 696:117414. Trip counts, daily-allowance countdown, all-time earnings and
  /// match stats are not in the profile API yet — those tiles render zeros
  /// until the backend exposes them.
  Widget _buildProfile() {
    final session = ref.watch(tifoSessionProvider);
    final profile = session.profile;
    final club = session.myClub;
    return ListView(
      shrinkWrap: true,
      children: [
        // Guest bearer gets a lazily-created staging profile, so a non-null
        // profile alone doesn't mean "signed in" — check isGuest too.
        if (session.isGuest || profile == null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: TifoColors.accentContainer,
              borderRadius: BorderRadius.circular(TifoRadii.l),
              border: Border.all(color: TifoColors.accent, width: 1.5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Please log in to view your profile.',
                    style: TifoText.captionMedium.copyWith(color: TifoColors.accent, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 10),
                Material(
                  color: const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(TifoRadii.ml),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(TifoRadii.ml),
                    // Host login flow (same as the app's Profile tab); the
                    // session reloads on return so the profile fills in.
                    onTap: () async {
                      await openHostLogin();
                      if (mounted) {
                        await ref.read(tifoSessionProvider.notifier).load();
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      child: Text('Log in', style: TifoText.bodyLSemi),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: TifoColors.accentContainer,
              borderRadius: BorderRadius.circular(TifoRadii.l),
              border: Border.all(color: TifoColors.accentMuted.withValues(alpha: 0.5), width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: club == null ? TifoColors.neutralFill : Color(club.colorArgb),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    club?.name ?? 'No team selected',
                    style: TifoText.bodyLSemi.copyWith(color: TifoColors.accent),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _StatTile(
                label: 'Current tokens',
                value: '${profile?.balance ?? 0}',
                chipBg: const Color(0xFFEDE9FE),
                icon: Icons.bolt_rounded,
                iconColor: const Color(0xFF7C3AED),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: _NextDailyTile(secondsToNextDaily: profile?.secondsToNextDaily)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _StatTile(
                label: 'Every trip you complete earns you tokens.',
                value: '${profile?.tripTokensToday ?? 0}',
                caption: 'Today',
                chipBg: const Color(0xFFE3F5EB),
                icon: Icons.location_on_rounded,
                iconColor: TifoColors.accentSoft,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatTile(
                label: 'Tokens earned',
                value: '${profile?.allTimeEarned ?? 0}',
                caption: 'All time',
                chipBg: const Color(0xFFE3F5EB),
                icon: Icons.account_balance_rounded,
                iconColor: TifoColors.accentSoft,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: TifoColors.surface,
            borderRadius: BorderRadius.circular(TifoRadii.l),
            border: Border.all(color: TifoColors.accentMuted.withValues(alpha: 0.5), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.sports_esports_rounded, size: 18, color: TifoColors.textStrong),
                  SizedBox(width: 8),
                  Text('Matches Played', style: TifoText.bodyLSemi),
                ],
              ),
              const SizedBox(height: 14),
              // US-10: Total / Won / Lose (no Draw) + "Claimed" = buildings
              // currently held. All four come from `/me` (stats block).
              Row(
                children: [
                  _MatchStat(
                    value: '${profile?.gamesTotal ?? 0}',
                    label: 'Total',
                    chipBg: const Color(0xFFF2F4F7),
                    icon: Icons.sports_esports_rounded,
                    iconColor: const Color(0xFF6A7282),
                  ),
                  _MatchStat(
                    value: '${profile?.gamesWon ?? 0}',
                    label: 'Wins',
                    chipBg: const Color(0xFFFFF4D6),
                    icon: Icons.emoji_events_rounded,
                    iconColor: const Color(0xFFD9A400),
                  ),
                  _MatchStat(
                    value: '${profile?.gamesLost ?? 0}',
                    label: 'Losses',
                    chipBg: const Color(0xFFFEE4E2),
                    icon: Icons.cancel_rounded,
                    iconColor: const Color(0xFFF04438),
                  ),
                  _MatchStat(
                    value: '${profile?.buildingsOwned ?? 0}',
                    label: 'Claimed',
                    chipBg: const Color(0xFFE3F5EB),
                    icon: Icons.apartment_rounded,
                    iconColor: TifoColors.accentSoft,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const Text('Recent Activity', style: TifoText.bodyLSemi),
        const SizedBox(height: 4),
        Text('No Data', style: TifoText.captionRegular.copyWith(fontSize: 13)),
      ],
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.tab, required this.onChanged});

  final int tab;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: _tabButton(AppLocalizations.of(context).table, 0)),
      const SizedBox(width: 8),
      Expanded(child: _tabButton(AppLocalizations.of(context).profile, 1)),
    ],
  );

  Widget _tabButton(String label, int index) {
    final active = tab == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(index),
      child: Container(
        height: 44,
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
      ),
    );
  }
}

class _LeaderRowTile extends StatelessWidget {
  const _LeaderRowTile({required this.row, required this.club});

  final TifoLeaderRow row;
  final TifoClubInfo? club;

  @override
  Widget build(BuildContext context) {
    final club = this.club;
    final color = club == null ? TifoColors.neutralFill : Color(club.colorArgb);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 20, child: Text('${row.rank}', style: TifoText.bodyLSemi)),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(club?.name ?? row.clubId, style: TifoText.bodyLSemi, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text('${row.districts}', style: TifoText.bodyL, textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 2,
            child: Text('${row.buildings}', style: TifoText.bodyL, textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${row.ownershipPct}%', style: TifoText.captionMedium.copyWith(color: TifoColors.textDefault)),
                const SizedBox(height: 3),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: (row.ownershipPct / 100).clamp(0, 1),
                    minHeight: 5,
                    backgroundColor: TifoColors.border,
                    valueColor: const AlwaysStoppedAnimation(TifoColors.accent),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 2),
          const Icon(Icons.chevron_right_rounded, size: 16, color: TifoColors.textSoft),
        ],
      ),
    );
  }
}

/// "Next daily tokens in" tile — counts down locally from the server's
/// `secondsToNextDaily` (the game day rolls at 00:00 Asia/Riyadh, so the
/// device clock and timezone can't be trusted to compute it).
class _NextDailyTile extends StatefulWidget {
  const _NextDailyTile({required this.secondsToNextDaily});

  final int? secondsToNextDaily;

  @override
  State<_NextDailyTile> createState() => _NextDailyTileState();
}

class _NextDailyTileState extends State<_NextDailyTile> {
  Timer? _ticker;
  late int _left = widget.secondsToNextDaily ?? 0;

  @override
  void initState() {
    super.initState();
    _restart();
  }

  @override
  void didUpdateWidget(_NextDailyTile old) {
    super.didUpdateWidget(old);
    // A profile refresh (daily claim, trip reward) re-seeds the countdown.
    if (old.secondsToNextDaily != widget.secondsToNextDaily) {
      _left = widget.secondsToNextDaily ?? 0;
      _restart();
    }
  }

  void _restart() {
    _ticker?.cancel();
    if (_left <= 0) {
      return;
    }
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _left = _left <= 1 ? 0 : _left - 1);
      if (_left == 0) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _left ~/ 3600;
    final minutes = (_left % 3600) ~/ 60;
    final seconds = _left % 60;
    final two = (int v) => v.toString().padLeft(2, '0');
    return _StatTile(
      label: 'Next daily tokens in',
      value: _left <= 0 ? '--' : '${two(hours)}:${two(minutes)}',
      caption: _left <= 0 ? 'hh:mm' : '${two(seconds)}s',
      chipBg: const Color(0xFFFFF1E0),
      icon: Icons.schedule_rounded,
      iconColor: const Color(0xFFD97706),
    );
  }
}

/// Dashboard stat tile (design 696:117570): caption label on top, icon chip +
/// big value below, green border.
class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.chipBg,
    required this.icon,
    required this.iconColor,
    this.caption,
  });

  final String label;
  final String value;
  final String? caption;
  final Color chipBg;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: TifoColors.surface,
      borderRadius: BorderRadius.circular(TifoRadii.l),
      border: Border.all(color: TifoColors.accentMuted.withValues(alpha: 0.5), width: 1.5),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TifoText.captionRegular.copyWith(fontSize: 12)),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(color: chipBg, shape: BoxShape.circle),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: TifoText.h3),
                  if (caption != null) Text(caption!, style: TifoText.captionRegular),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

/// One column of the "Matches Played" card: colored icon chip, value, label.
class _MatchStat extends StatelessWidget {
  const _MatchStat({
    required this.value,
    required this.label,
    required this.chipBg,
    required this.icon,
    required this.iconColor,
  });

  final String value;
  final String label;
  final Color chipBg;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: chipBg, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(height: 6),
        Text(value, style: TifoText.h3),
        Text(label, style: TifoText.captionRegular),
      ],
    ),
  );
}
