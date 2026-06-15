import 'package:flutter/material.dart';
import 'package:mapness/features/tifo/team_dashboard_screen.dart';
import 'package:mapness/features/tifo/tifo_team.dart';

/// STEP 2 of 3 — Set Up Tifo. Figma node 1:7202.
class TifoSettingsScreen extends StatefulWidget {
  const TifoSettingsScreen({super.key, required this.team});

  final TifoTeam team;

  static const Color _bg = Color(0xFF0A0A0A);
  static const Color _cardBg = Color(0xFF141414);
  static const Color _textPrimary = Color(0xFFF5F5F5);
  static const Color _textBody = Color(0xFFE0E0E0);
  static const Color _textMuted = Color(0xFF616161);
  static const Color _accent = Color(0xFF16A34A);
  static const Color _accentLight = Color(0xFF22C55E);

  @override
  State<TifoSettingsScreen> createState() => _TifoSettingsScreenState();
}

class _TifoSettingsScreenState extends State<TifoSettingsScreen> {
  bool _districtAttacks = true;
  bool _rewardsReady = true;
  bool _seasonUpdates = false;
  bool _backgroundLocation = false;
  bool _anonymousMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TifoSettingsScreen._bg,
      body: Column(
        children: [
          _StepHeader(
            stepText: 'STEP 2 OF 3',
            title: 'Set Up Tifo',
            progress: 2,
            onBack: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TeamPill(team: widget.team),
                  const SizedBox(height: 12),
                  _SettingsCard(
                    title: 'NOTIFICATIONS',
                    rows: [
                      _SettingRow(
                        title: 'District attacks',
                        subtitle: 'Alert when your districts are threatened',
                        value: _districtAttacks,
                        onChanged: (v) => setState(() => _districtAttacks = v),
                      ),
                      _SettingRow(
                        title: 'Rewards ready',
                        subtitle: 'When districts produce rewards',
                        value: _rewardsReady,
                        onChanged: (v) => setState(() => _rewardsReady = v),
                      ),
                      _SettingRow(
                        title: 'Season updates',
                        subtitle: 'Rankings, milestones and events',
                        value: _seasonUpdates,
                        onChanged: (v) => setState(() => _seasonUpdates = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SettingsCard(
                    title: 'LOCATION',
                    rows: [
                      _SettingRow(
                        title: 'Background location',
                        subtitle: 'Auto-capture districts as you move through the city',
                        value: _backgroundLocation,
                        onChanged: (v) => setState(() => _backgroundLocation = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SettingsCard(
                    title: 'PRIVACY',
                    rows: [
                      _SettingRow(
                        title: 'Anonymous mode',
                        subtitle: 'Hide your name from public leaderboards',
                        value: _anonymousMode,
                        onChanged: (v) => setState(() => _anonymousMode = v),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _ActivateCta(
            onTap: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  fullscreenDialog: true,
                  builder: (_) => TifoTeamDashboardScreen(team: widget.team),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Header (shared shape with team-select) ──────────────────────────────────

class _StepHeader extends StatelessWidget {
  const _StepHeader({
    required this.stepText,
    required this.title,
    required this.progress,
    required this.onBack,
  });

  final String stepText;
  final String title;
  final int progress;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onBack,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                        width: 0.75,
                      ),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 14,
                      color: TifoSettingsScreen._textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      stepText,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8,
                        height: 12 / 8,
                        letterSpacing: 0.8,
                        color: TifoSettingsScreen._accentLight,
                      ),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 24 / 16,
                        color: TifoSettingsScreen._textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                for (var i = 1; i <= 3; i++) ...[
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: i <= progress
                            ? TifoSettingsScreen._accentLight
                            : Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  if (i < 3) const SizedBox(width: 6),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Team pill (YOUR TEAM / Al Hilal) ────────────────────────────────────────

class _TeamPill extends StatelessWidget {
  const _TeamPill({required this.team});

  final TifoTeam team;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: team.primary.withOpacity(0.14),
        border: Border.all(color: team.primary.withOpacity(0.19), width: 0.75),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: team.primary.withOpacity(0.14),
              border: Border.all(
                color: team.primary.withOpacity(0.25),
                width: 0.75,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: const Text(
              '🏟',
              style: TextStyle(fontSize: 20, height: 1.0),
            ),
          ),
          const SizedBox(width: 12),
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
                    letterSpacing: 0.225,
                    color: team.primary,
                  ),
                ),
                Text(
                  team.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    height: 19.5 / 13,
                    color: team.primary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.edit_outlined,
            size: 16,
            color: team.primary,
          ),
        ],
      ),
    );
  }
}

// ─── Settings card (caption + rows) ──────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.title, required this.rows});

  final String title;
  final List<_SettingRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TifoSettingsScreen._cardBg,
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
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                height: 13.5 / 9,
                letterSpacing: 0.9,
                color: TifoSettingsScreen._accentLight,
              ),
            ),
          ),
          for (var i = 0; i < rows.length; i++) ...[
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.05),
                    width: 0.75,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: rows[i],
            ),
          ],
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  height: 18 / 12,
                  color: TifoSettingsScreen._textBody,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10,
                  height: 15 / 10,
                  color: TifoSettingsScreen._textMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Transform.scale(
          scale: 0.85,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: TifoSettingsScreen._accent,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.12),
          ),
        ),
      ],
    );
  }
}

// ─── Bottom CTA (Activate Tifo) ──────────────────────────────────────────────

class _ActivateCta extends StatelessWidget {
  const _ActivateCta({required this.onTap});

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
                    TifoSettingsScreen._accent,
                    TifoSettingsScreen._accentLight,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: TifoSettingsScreen._accent.withOpacity(0.28),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Text(
                'Activate Tifo',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  height: 22.5 / 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
