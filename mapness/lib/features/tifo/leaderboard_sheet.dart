import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/data/tifo_api.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/features/tifo/providers/tifo_session_provider.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';

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
              alignment: Alignment.centerRight,
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
              label: 'Dominate with your team',
              trailingArrow: true,
              onPressed: () => Navigator.of(context).pop(),
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
          const TifoInfoBanner(
            icon: Icons.emoji_events_rounded,
            title: 'The battle for control continues!',
            subtitle: 'Compete with other teams to claim the city.',
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: TifoColors.surface,
              borderRadius: BorderRadius.circular(TifoRadii.ml),
              border: Border.all(color: TifoColors.border),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(width: 20, child: Text('#', style: TifoText.captionMedium)),
                      Expanded(flex: 4, child: Text('Team', style: TifoText.captionMedium)),
                      Expanded(
                        flex: 2,
                        child: Text('Districts\nClaimed', style: TifoText.captionMedium, textAlign: TextAlign.center),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('Buildings\nClaimed', style: TifoText.captionMedium, textAlign: TextAlign.center),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text('Map\nDominance', style: TifoText.captionMedium, textAlign: TextAlign.end),
                      ),
                      SizedBox(width: 16),
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
                const Icon(Icons.bolt_rounded, size: 18, color: TifoColors.accentSoft),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Take over more buildings to dominate the table.',
                    style: TifoText.captionMedium.copyWith(color: TifoColors.accentSoft),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    final session = ref.watch(tifoSessionProvider);
    final profile = session.profile;
    final club = session.myClub;
    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TifoColors.accentContainer,
            borderRadius: BorderRadius.circular(TifoRadii.ml),
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
                  club?.name ?? (profile == null ? 'Not logged in' : 'No team selected'),
                  style: TifoText.bodyLSemi,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatTile(label: 'Current tokens', value: '${profile?.balance ?? 0}'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatTile(label: 'Buildings owned', value: '${profile?.buildingsOwned ?? 0}'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatTile(label: 'Free claims left', value: '${profile?.freeClaimsRemaining ?? 0}'),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: _StatTile(label: 'Recent activity', value: '—'),
            ),
          ],
        ),
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
      Expanded(child: _tabButton('Table', 0)),
      const SizedBox(width: 8),
      Expanded(child: _tabButton('Profile', 1)),
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

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: TifoColors.surface,
      borderRadius: BorderRadius.circular(TifoRadii.ml),
      border: Border.all(color: TifoColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TifoText.captionRegular),
        const SizedBox(height: 6),
        Text(value, style: TifoText.h3.copyWith(color: TifoColors.accentSoft)),
      ],
    ),
  );
}
