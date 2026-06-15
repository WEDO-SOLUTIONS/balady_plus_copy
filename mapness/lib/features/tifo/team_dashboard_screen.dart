import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/tifo_flow_provider.dart';
import 'package:mapness/features/tifo/tifo_team.dart';

/// STEP 3 of 3 — Team dashboard with "TIFO ACTIVATED" badge. Figma node 1:7289.
class TifoTeamDashboardScreen extends ConsumerStatefulWidget {
  const TifoTeamDashboardScreen({super.key, required this.team});

  final TifoTeam team;

  static const Color _bg = Color(0xFF0A0A0A);
  static const Color _cardBg = Color(0xFF141414);
  static const Color _textPrimary = Color(0xFFF5F5F5);
  static const Color _textMuted = Color(0xFF616161);
  static const Color _accent = Color(0xFF16A34A);
  static const Color _accentLight = Color(0xFF22C55E);

  @override
  ConsumerState<TifoTeamDashboardScreen> createState() =>
      _TifoTeamDashboardScreenState();
}

class _TifoTeamDashboardScreenState
    extends ConsumerState<TifoTeamDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Reaching this screen means the user finished the team-selection flow.
    // Flip the flag so the next ⚽ tap triggers the tutorial.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(tifoFlowProvider.notifier).markTeamSelected();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TifoTeamDashboardScreen._bg,
      body: Column(
        children: [
          _Hero(team: widget.team),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: const [
                  _SeasonTerritory(),
                  SizedBox(height: 12),
                  _QuickActions(),
                ],
              ),
            ),
          ),
          _ViewRewardsCta(
            onTap: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ],
      ),
    );
  }
}

// ─── Hero: gradient bg, team name, stats, "TIFO ACTIVATED" pill ──────────────

class _Hero extends StatelessWidget {
  const _Hero({required this.team});

  final TifoTeam team;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            team.primary.withOpacity(0.14),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "TIFO ACTIVATED" pill.
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                decoration: BoxDecoration(
                  color: const Color(0xFF16A34A).withOpacity(0.14),
                  border: Border.all(
                    color: const Color(0xFF16A34A).withOpacity(0.28),
                    width: 0.75,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Color(0xFF22C55E),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'TIFO ACTIVATED',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        height: 15 / 10,
                        color: Color(0xFF22C55E),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Team name + stadium icon.
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YOUR TEAM',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 9,
                            height: 13.5 / 9,
                            letterSpacing: 0.9,
                            color: team.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          team.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            height: 32 / 24,
                            color: TifoTeamDashboardScreen._textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: team.primary.withOpacity(0.14),
                      border: Border.all(
                        color: team.primary.withOpacity(0.25),
                        width: 0.75,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '🏟',
                      style: TextStyle(fontSize: 30, height: 1.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Stats row.
              Row(
                children: [
                  Expanded(child: _StatCard(value: '12', label: 'Districts', color: team.primary)),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(value: '#2', label: 'Season Rank', color: team.primary)),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(value: '8.4K', label: 'Points', color: team.primary)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xCC141414), // rgba(20,20,20,0.8)
        border: Border.all(
          color: color.withOpacity(0.13),
          width: 0.75,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              height: 28 / 18,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 8,
              height: 12 / 8,
              color: TifoTeamDashboardScreen._textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Season territory progress bar ───────────────────────────────────────────

class _SeasonTerritory extends StatelessWidget {
  const _SeasonTerritory();

  static const _segments = <(TifoTeam, int)>[
    (TifoTeam.alHilal, 121),
    (TifoTeam.alNassr, 102),
    (TifoTeam.riyadhFc, 66),
    (TifoTeam.alShabab, 39),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TifoTeamDashboardScreen._cardBg,
        border: Border.all(
          color: Colors.white.withOpacity(0.07),
          width: 0.75,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: const Text(
              'SEASON TERRITORY',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                height: 13.5 / 9,
                letterSpacing: 0.9,
                color: Color(0xFF22C55E),
              ),
            ),
          ),
          Container(
            height: 0.75,
            color: Colors.white.withOpacity(0.05),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stacked progress bar.
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 10,
                    child: Row(
                      children: [
                        for (final (team, w) in _segments)
                          Expanded(
                            flex: w,
                            child: Container(color: team.primary),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Legend.
                Row(
                  children: [
                    for (final (team, _) in _segments) ...[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: team.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        team.code,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 8,
                          height: 12 / 8,
                          color: team.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Quick actions: 2×2 grid ─────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  static const _items = <_QuickActionData>[
    _QuickActionData(emoji: '🗺', title: 'City War Map', subtitle: 'See the full battle'),
    _QuickActionData(emoji: '🏘', title: 'My Districts', subtitle: '12 owned territories'),
    _QuickActionData(emoji: '💎', title: 'Rewards', subtitle: '3 ready to claim'),
    _QuickActionData(emoji: '📊', title: 'Season Rank', subtitle: '#2 of 4 teams'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: const Text(
            'QUICK ACTIONS',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              height: 13.5 / 9,
              letterSpacing: 0.9,
              color: Color(0xFF22C55E),
            ),
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 175 / 88,
          children: [
            for (final item in _items) _QuickActionCard(data: item),
          ],
        ),
      ],
    );
  }
}

class _QuickActionData {
  const _QuickActionData({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  final String emoji;
  final String title;
  final String subtitle;
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.data});

  final _QuickActionData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TifoTeamDashboardScreen._cardBg,
        border: Border.all(
          color: Colors.white.withOpacity(0.07),
          width: 0.75,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.emoji,
            style: const TextStyle(fontSize: 20, height: 1.0),
          ),
          const SizedBox(height: 8),
          Text(
            data.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11,
              height: 16.5 / 11,
              color: TifoTeamDashboardScreen._textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.subtitle,
            style: const TextStyle(
              fontSize: 9,
              height: 13.5 / 9,
              color: TifoTeamDashboardScreen._textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom CTA — View Your Rewards → pop back to dashboard ──────────────────

class _ViewRewardsCta extends StatelessWidget {
  const _ViewRewardsCta({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0x0FFFFFFF), width: 0.75),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              height: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    TifoTeamDashboardScreen._accent,
                    TifoTeamDashboardScreen._accentLight,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: TifoTeamDashboardScreen._accent.withOpacity(0.28),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'View Your Rewards',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      height: 22.5 / 15,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
